require 'rubygems'
require 'pit'
require 'test/unit'
require 'gena/mail.rb'

class MailTest < Test::Unit::TestCase
  def test_send
    config = Pit.get('gena_mail_test', :require => {
      'host' => 'smtp.gmail.com',
      'port' => '587',
      'account' => 'your account',
      'password' => 'your password',
      'from' => 'your FROM address',
      'to' => 'your TO address'
    })
    mail = Gena::Mail.new config

    mail['To']  = config['to']
    mail['From']  = config['from']
    mail['Subject'] = 'てすとです'

    body = 'こんにちは！'
    mail << body

    mail.send

    assert true
  end
end
