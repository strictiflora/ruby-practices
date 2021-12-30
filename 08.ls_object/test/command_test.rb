# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../command'
require_relative '../long_format'
require_relative '../short_format'

class LS::CommandTest < Minitest::Test
  # /test/dummyで実行
  def setup
    paths = ['567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    @long_format = LS::LongFormat.new(paths)
    @short_format = LS::ShortFormat.new(paths)
  end

  def test_ls_command1
    expected = <<~TEXT.chomp
      567.txt      Sample.txt      sample.text
      73.txt       defgh.txt       z.txt      
      Apple        directory       zz.txt     
      CDE          dummy.txt       zzz.txt    
    TEXT
    assert_equal expected, LS::Command.new({ l: false }, @long_format, @short_format).execute
  end

  def test_ls_command2
    expected = <<~TEXT.chomp
      total 56
      -rw-------  1 kino  staff  1536 12 30 13:53 567.txt
      -rw-------  1 kino  staff  1024 12 30 13:54 73.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:56 Apple
      -rw-r--r--  1 kino  staff     0 12 30 13:56 CDE
      -rw-------  1 kino  staff  2048 12 30 13:50 Sample.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:58 defgh.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:58 directory
      -rw-------  1 kino  staff   512 12 30 13:51 dummy.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:49 sample.text
      -rw-------  1 kino  staff   512 12 30 13:54 z.txt
      -rw-------  1 kino  staff   512 12 30 13:55 zz.txt
      -rw-------  1 kino  staff   512 12 30 13:55 zzz.txt
    TEXT
    assert_equal expected, LS::Command.new({ l: true }, @long_format, @short_format).execute
  end
end
