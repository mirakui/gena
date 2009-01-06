require 'rubygems'
require 'pit'
require 'gena/mail'

module Gena
  class PitMail
    def initialize(pit_name)
      @config = Pit.get(pit_name, :require => {
        'host' => 'hostname(smtp.gmail.com)',
        'port' => '25(normal)587(gmail)',
        'account' => 'your_smpt_account',
        'password' => 'your_password',
        'from' => 'your_FROM_address',
        'to' => 'your_TO_address',
      })
    end

    def send(param={})
      config = @config.merge param
      mail = Mail.new config

      mail['To'] = config['to']
      mail['From']  = config['account']
      mail['Subject'] = config['subject']
      mail << config['body']

      mail.send
    end
  end
end

