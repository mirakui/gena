require 'rubygems'
require 'pit'
require 'test/unit'
require 'gena/gmail.rb'

class GmailTest < Test::Unit::TestCase
  def test_send
    subject = 'GmailTestのテスト'
    body = 'こんにちは！'
    Gena::Gmail.send subject, body

    assert true
  end
end

