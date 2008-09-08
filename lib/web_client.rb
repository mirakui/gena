require 'rubygems'
require 'net/https'
require 'hpricot'
require 'kconv'
require 'cgi'
require 'pp'


module Gena
  class WebClient
    attr_accessor :cookie
    attr_accessor :user_agent

    def initialize
      @cookie = ''
      @user_agent = 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)'
    end

    def post(uri, data)
      uri = URI.parse(uri) unless uri.class == URI
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      req = Net::HTTP::Post.new(uri.path)
      data.each {|k,v| req[k]=v} if data.class == Hash
      req['Content-Length'] ||= 100
      puts req.content_length
      #req['Content-Length'] ||= data.length.to_s
      #req['User-Agent'] ||= @user_agent
      req['Cookie'] ||= @cookie

      res = http.request(req)
      yield res
    end

    def get(uri)
      uri = URI.parse(uri) unless uri.class == URI
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      req = Net::HTTP::Get.new(uri.path)

      req['User-Agent'] ||= @user_agent
      req['Cookie'] ||= @cookie

      res = http.request(req)
      yield res
    end

    def _get(uri)
      uri = URI.parse(uri) unless uri.class == URI
      Net::HTTP.start(uri.host, uri.port) do |w|
        res = w.get(uri.path, 'User-Agent'=>@user_agent, 'Cookie'=>@cookie)
        @cookie = res['Set-Cookie']
        yield res
      end
    end

  end
end

class String
  def parse_html
    Hpricot.parse(self)
  end
end

module Net
  class HTTPResponse
    def parse_body
      body.parse_html
    end
  end
end

class Hash
  def to_req_s
    (self.map {|k, v| "#{k}=#{v}"}).join '&'
  end
end


