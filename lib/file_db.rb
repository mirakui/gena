require 'gena/yaml_waml'

module Gena
  class FileDB
    attr_reader :path
    ROLL_DATE_FORMAT = {:daily=>'.%y%m%d_%H%M'}

    def initialize(path, param={})
      base = param[:base]
      @base = base ? (
        File.file?(base) ? File.dirname(base) : base
      ) : nil
      @path = @base ? File.join(@base, path) : path
    end

    def read
      text = nil
      if File.exist?(@path)
        File.open(@path, 'r') {|f| text = f.read}
      end
      text
    end

    def write(text)
      File.open(@path, 'w') {|f| f.write text}
      text
    end

    def read_yaml
      r = read
      r ? YAML.load(r) : nil
    end

    def write_yaml(obj)
      write obj.to_yaml
    end

    def delete
      File.delete @path
    end

    def exist?
      File.exist? @path
    end

    def roll(mode=:daily)
      if exist?
        format      = ROLL_DATE_FORMAT[mode]
        mtime       = File.mtime(@path).strftime(format)
        rolled_name = @path + mtime
        File.rename @path, rolled_name if exist?
        true
      else
        false
      end
    end
  end
end
__END__
