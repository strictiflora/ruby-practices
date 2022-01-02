# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/path'

class LS::PathTest < Minitest::Test
  # /test/dummyで実行
  def test_path1
    expected = ['567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::Path.new({ a: false, r: false }).paths
  end

  def test_path2
    expected = ['.', '..', '567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', \
                'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::Path.new({ a: true, r: false }).paths
  end

  def test_path3
    expected = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', 'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt']
    assert_equal expected, LS::Path.new({ a: false, r: true }).paths
  end

  def test_path4
    expected = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', \
                'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt', '..', '.']
    assert_equal expected, LS::Path.new({ a: true, r: true }).paths
  end
end
