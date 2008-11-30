require 'rubygems'
require 'test/unit'
require 'gena/file_util'

class GenaFileTest < Test::Unit::TestCase
  def test_all
    base = '/tmp'
    path = 'gena_file_test'
    text = 'hello'
    f = Gena::FileUtil.new path, :base=>'tmp'
    f.write(text)
    read = f.read
    assert !(read.nil?)
    assert read==text
    f.delete
    assert !File.exist?(f.path)
  end
end
