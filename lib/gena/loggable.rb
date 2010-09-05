require 'logger'

module Gena
  module Loggable
    def logger
      unless defined? @logger
        @logger = Logger.new(STDOUT)
        @logger.formatter = Logger::Formatter.new
        @logger.level = Logger::DEBUG
      end
      @logger
    end

    def logger=(logger)
      @logger = logger
    end
  end
end
