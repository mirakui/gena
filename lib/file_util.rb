module Gena
  class FileUtil
    attr_reader :path

    def initialize(path, param={})
      base = param[:base]
      @base = base ? (
        File.file?(base) ? File.dirname(base) : base
      ) : nil
      @path = @base ? path : File.join(@base, path)
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

    def delete
      File.delete @path
    end
  end
end
__END__
