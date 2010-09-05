require 'twitter_oauth'
require 'pit'
require File.join(File.dirname(__FILE__), '..', 'loggable.rb')

module Gena
  class TwitterError < Exception
    attr_reader :error_obj
    def initialize(obj=nil)
      @error_obj = obj
      super(obj.inspect)
    end
  end

  class Twitter
    include Gena::Loggable

    attr_reader :pit
    attr_accessor :readonly

    def initialize(pit)
      @pit = pit
      @readonly = false
    end

    def self.load_pit(pit_name)
      pit = Pit.get pit_name, :require => {
        'consumer_key'    => '',
        'consumer_secret' => '',
        'access_token'    => '',
        'access_secret'   => ''
      }
      Twitter.new pit
    end

    def update(msg, opts={})
      unless @readonly
        twitter.update msg, opts
        logger.info "posted to twitter: #{msg} (#{opts.inspect})"
      else
        logger.warn "didn't post to twitter: #{msg} (#{opts.inspect})"
      end
    end
    alias :post :update

    def reply_to(target_status, msg)
      update "@#{target_status['user']['screen_name']} #{msg}", :in_reply_to_status_id => target_status['id']
    end

    def followers_ids(opt={})
      send_twitter :followers_ids, opt
    end

    def mentions(opt={})
      send_twitter :mentions, opt
    end

    def friends_timeline(opt={})
      send_twitter :friends_timeline, opt
    end

    private
    def twitter
      unless defined? @twitter
        @twitter = TwitterOAuth::Client.new(
          :consumer_key=>pit['consumer_key'],
          :consumer_secret=>pit['consumer_secret'],
          :token=>pit['access_token'],
          :secret=>pit['access_secret']
        )
      end
      @twitter
    end

    def send_twitter(method_name, *opts)
      res = twitter.send(method_name.to_s, *opts)
      if res.is_a?(Hash) && res.has_key('error') 
        raise TwitterBotError.new(res)
      end
      res
    end
  end
end

