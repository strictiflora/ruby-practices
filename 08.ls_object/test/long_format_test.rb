# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/long_format'

class LS::LongFormatTest < Minitest::Test
  # /test/dummyで実行
  def test_long_format1
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
    paths = ['567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::LongFormat.new(paths).display
  end

  def test_long_format2
    expected = <<~TEXT.chomp
      total 56
      drwxr-xr-x  14 kino  staff   448 12 30 18:04 .
      drwxr-xr-x   6 kino  staff   192  1  4 14:28 ..
      -rw-------   1 kino  staff  1536 12 30 13:53 567.txt
      -rw-------   1 kino  staff  1024 12 30 13:54 73.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:56 Apple
      -rw-r--r--   1 kino  staff     0 12 30 13:56 CDE
      -rw-------   1 kino  staff  2048 12 30 13:50 Sample.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:58 defgh.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:58 directory
      -rw-------   1 kino  staff   512 12 30 13:51 dummy.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:49 sample.text
      -rw-------   1 kino  staff   512 12 30 13:54 z.txt
      -rw-------   1 kino  staff   512 12 30 13:55 zz.txt
      -rw-------   1 kino  staff   512 12 30 13:55 zzz.txt
    TEXT
    paths = ['.', '..', '567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::LongFormat.new(paths).display
  end

  def test_long_format3
    expected = <<~TEXT.chomp
      total 56
      -rw-------  1 kino  staff   512 12 30 13:55 zzz.txt
      -rw-------  1 kino  staff   512 12 30 13:55 zz.txt
      -rw-------  1 kino  staff   512 12 30 13:54 z.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:49 sample.text
      -rw-------  1 kino  staff   512 12 30 13:51 dummy.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:58 directory
      -rw-r--r--  1 kino  staff     0 12 30 13:58 defgh.txt
      -rw-------  1 kino  staff  2048 12 30 13:50 Sample.txt
      -rw-r--r--  1 kino  staff     0 12 30 13:56 CDE
      -rw-r--r--  1 kino  staff     0 12 30 13:56 Apple
      -rw-------  1 kino  staff  1024 12 30 13:54 73.txt
      -rw-------  1 kino  staff  1536 12 30 13:53 567.txt
    TEXT
    paths = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', 'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt']
    assert_equal expected, LS::LongFormat.new(paths).display
  end

  def test_long_format4
    expected = <<~TEXT.chomp
      total 56
      -rw-------   1 kino  staff   512 12 30 13:55 zzz.txt
      -rw-------   1 kino  staff   512 12 30 13:55 zz.txt
      -rw-------   1 kino  staff   512 12 30 13:54 z.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:49 sample.text
      -rw-------   1 kino  staff   512 12 30 13:51 dummy.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:58 directory
      -rw-r--r--   1 kino  staff     0 12 30 13:58 defgh.txt
      -rw-------   1 kino  staff  2048 12 30 13:50 Sample.txt
      -rw-r--r--   1 kino  staff     0 12 30 13:56 CDE
      -rw-r--r--   1 kino  staff     0 12 30 13:56 Apple
      -rw-------   1 kino  staff  1024 12 30 13:54 73.txt
      -rw-------   1 kino  staff  1536 12 30 13:53 567.txt
      drwxr-xr-x   6 kino  staff   192  1  4 14:28 ..
      drwxr-xr-x  14 kino  staff   448 12 30 18:04 .
    TEXT
    paths = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', 'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt', '..', '.']
    assert_equal expected, LS::LongFormat.new(paths).display
  end
end
