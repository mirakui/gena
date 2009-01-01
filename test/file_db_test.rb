require 'rubygems'
require 'test/unit'
require 'gena/file_db'

class FileDBTest < Test::Unit::TestCase
  def test_all
    base = '/tmp'
    path = 'gena_file_db_test'
    text = 'hello'
    f = Gena::FileDB.new path, :base=>base
    f.write(text)
    read = f.read
    assert !(read.nil?)
    assert read==text
    f.delete
    assert !File.exist?(f.path)
  end
end
