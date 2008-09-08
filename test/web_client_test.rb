require 'rubygems'
require 'pit'
require 'test/unit'
require 'gena/web_client'
require 'open-uri'

class WebClientTest < Test::Unit::TestCase
  def setup
    @client = Gena::WebClient.new
  end
  
  def test_get
    @client.get('http://www.yahoo.co.jp/') do |res|
      doc = res.parse_body
      assert (doc/'.emphasis a').length > 0
    end
  end

  def test_post
    conf = Pit.get('twitter', :require=> {
      'username' => 'your twitter id or email',
      'password' => 'your twitter password'
    })

    data = {
     'session[username_or_email]'=>conf['username'],
     'session[password]'=>conf['password']
    }

    @client.post('http://twitter.com/sessions', data) do |res|
      doc = res.parse_body
      #puts doc.inner_text
      puts res.code
    end
  end
end

