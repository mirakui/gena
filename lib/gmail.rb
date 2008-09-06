require 'gena/mail.rb'


module Gena
  class Gmail < Mail
    def self.send(subject, body)
      config = Pit.get('gena_gmail', :require => {
        'host' => 'smtp.gmail.com',
        'port' => '587',
        'account' => 'your gmail address',
        'password' => 'your password',
        'to' => 'your TO address'
      })
      mail = Mail.new config

      mail['To']  = config['to']
      mail['From']  = config['account']
      mail['Subject'] = subject
      mail << body

      mail.send
    end
  end
end
