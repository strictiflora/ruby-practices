# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/stat'

class LS::StatTest < Minitest::Test
  # /test/dummyで実行
  def test_stat1
    expected = '-rw-------'
    assert_equal expected, LS::Stat.new('567.txt').mode
  end

  def test_stat2
    expected = 1
    assert_equal expected, LS::Stat.new('567.txt').nlink
  end

  def test_stat3
    expected = 'kino'
    assert_equal expected, LS::Stat.new('567.txt').owner
  end

  def test_stat4
    expected = 'staff'
    assert_equal expected, LS::Stat.new('567.txt').group
  end

  def test_stat5
    expected = 1536
    assert_equal expected, LS::Stat.new('567.txt').size
  end

  def test_stat6
    expected = '12 30 13:53'
    assert_equal expected, LS::Stat.new('567.txt').timestamp
  end

  def test_stat7
    expected = '567.txt'
    assert_equal expected, LS::Stat.new('567.txt').name
  end
end
