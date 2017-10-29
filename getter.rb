require 'httparty'
require 'json'

module Bondis
  class Getter
    include HTTParty
    base_uri 'https://www.gpsbahia.com.ar/'

    LINEAS = {
      "3" => "319",
      "4" => "500",
      "5" => "502",
      "6" => "503",
      "7" => "504",
      "31" => "504 EX",
      "8" => "505",
      "9" => "506",
      "10" => "507",
      "1" => "509",
      "11" => "512",
      "12" => "513",
      "13" => "513 EX",
      "14" => "514",
      "15" => "516",
      "16" => "517",
      "17" => "518",
      "18" => "519",
      "19" => "519 A",
      "30" => "520"
    }

    QUERY_DEFAULTS = {
      # :http_proxyaddr => nil
      # :http_proxyport => nil
    }

    def get_token!
      self.class.get("/").body =~ /([a-f0-9]{40})/
      @token = $1
    end

    def token=(t)
      @token = t
    end

    def get_linea_data(id)
      JSON.parse self.class.post("/web/get_linea_data/#{id}/#{@token}").body
    end

    def get_track_data(id)
      puts id, @token
      JSON.parse self.class.post("/web/get_track_data/#{id}/#{@token}").body
    end
  end
end
