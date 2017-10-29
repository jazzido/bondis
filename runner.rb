require 'thread'
require 'slop'

require_relative './getter'

module Bondis
  class Runner

    def initialize(writer, interval)
      @writer = writer
      @interval = interval
    end

    def run!
      Getter::LINEAS.map { |id, linea|
        start_thread(id, linea)
      }.each { |t| t.join }
    end


    private
    def start_thread(id, linea)
      Thread.new do
        getter = Getter.new
        getter.get_token!
        loop do
          begin
            d = getter.get_track_data(id)
            @writer.write_records(d['data'])
            sleep @interval
          rescue
            # refresh token, just in case
            getter.get_token!
          end
        end
      end
    end
  end

  class Writer
    def initialize(output_path)
      @csv = CSV.open(output_path, 'a')
      @mutex = Mutex.new
    end

    def write_records(records)
      @mutex.synchronize do
        records.each { |rec|
          @csv << rec.values
        }
      end
    end
  end
end

if __FILE__ == $0
  opts = Slop.parse do |o|
    o.integer '-i', '--interval', 'Interval in seconds', default: 5
    o.string '-o', '--output', 'Output file', required: true
  end

  w = Bondis::Writer.new(opts[:output])
  r = Bondis::Runner.new(w, opts[:interval])

  r.run!
end


