require 'rubygems'
require 'pit'
require 'net/smtp'
require "base64"
require 'tlsmail'

=begin
  class Mail
  A simple smtp client
  from http://genmei.itline.jp/~svx/diary/?date=20050415

  Please install also:
  gem install tlsmail
  gem install pit
=end
module Gena
  class Mail

    attr_reader   :header
    attr_reader   :body

# Initialize メールオブジェクトを生成する
    def initialize(config=nil, mail=nil)  # mail = Array or IO(ex.STDIN) or nil key     = nil
      @header = {}
      @body   = []
      @config = config || {}

      return if mail == nil

      inBody = false
      mail.each {|line|
        line.chomp!
        unless inBody
          if line =~ /^$/         # 空行
            inBody = true
          elsif line =~ /^(\S+?):\s*(.*)/ # ヘッダ行
            key = $1.capitalize
            @header[key] = $2
          elsif key           # ヘッダ行が2行に渡る場合
            @header[key] += "\n" + line.sub(/^\s*/, "\t")
          end
        else
          @body.push(line)
        end
      }

      mail['Content-Type'] = "text/plain; charset=UTF-8"
    end

# [] ヘッダを参照
    def [](key)
      @header[key.capitalize]
    end

# []= ヘッダを設定
    def []=(key, value)
      if key.capitalize=='Subject'
        value = value.mime_encode
      end
      @header[key.capitalize] = value
    end

# << ボディにテキストを追加
    def <<(message)
      @body.push message
    end

# encode メールをテキストストリームにエンコード
    def encode
      mail = ""
      @header.each {|key, value|
        mail += "#{key}: #{value}\n"
      }
      mail += "\n"              # ヘッダ/ボディのセパレータ
      mail += @body.join '\n'
      return mail
    end

# send メールを送る
    def send(from = nil, *to)
      from  = @header['From'] unless from
      to.push @header['To']   if to.size == 0
      smtp = Net::SMTP.new(@config['host'] || "localhost", @config['port'])
      smtp.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      smtp.start(@config['helo'] || "localhost", @config['account'], @config['password'], :login) {|smtp|
        smtp.send_mail(self.encode, from, *to)
      }
    end
  end

end

# String
class String

  def mime_encode
    return "=?ISO-2022-JP?B?" + Base64.encode64(self.tojis).gsub!(/\n/, "") + "?="
  end

  def mime_decode
    return self unless self =~ /^=\?ISO-2022-JP\?B\?(.+)\?=$/i
    return Base64.decode64($1)
  end
end

