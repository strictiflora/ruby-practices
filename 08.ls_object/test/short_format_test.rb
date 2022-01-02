# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/short_format'

class LS::ShortFormatTest < Minitest::Test
  def test_short_format1
    expected = <<~TEXT.chomp
      567.txt      Sample.txt      sample.text
      73.txt       defgh.txt       z.txt      
      Apple        directory       zz.txt     
      CDE          dummy.txt       zzz.txt    
    TEXT
    paths = ['567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::ShortFormat.new(paths).display
  end

  def test_short_format2
    expected = <<~TEXT.chomp
      .            CDE             sample.text
      ..           Sample.txt      z.txt      
      567.txt      defgh.txt       zz.txt     
      73.txt       directory       zzz.txt    
      Apple        dummy.txt       
    TEXT
    paths = ['.', '..', '567.txt', '73.txt', 'Apple', 'CDE', 'Sample.txt', 'defgh.txt', 'directory', 'dummy.txt', 'sample.text', 'z.txt', 'zz.txt', 'zzz.txt']
    assert_equal expected, LS::ShortFormat.new(paths).display
  end

  def test_short_format3
    expected = <<~TEXT.chomp
      zzz.txt          dummy.txt       CDE    
      zz.txt           directory       Apple  
      z.txt            defgh.txt       73.txt 
      sample.text      Sample.txt      567.txt
    TEXT
    paths = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', 'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt']
    assert_equal expected, LS::ShortFormat.new(paths).display
  end

  def test_short_format4
    expected = <<~TEXT.chomp
      zzz.txt          directory       73.txt 
      zz.txt           defgh.txt       567.txt
      z.txt            Sample.txt      ..     
      sample.text      CDE             .      
      dummy.txt        Apple           
    TEXT
    paths = ['zzz.txt', 'zz.txt', 'z.txt', 'sample.text', 'dummy.txt', 'directory', 'defgh.txt', 'Sample.txt', 'CDE', 'Apple', '73.txt', '567.txt', '..', '.']
    assert_equal expected, LS::ShortFormat.new(paths).display
  end
end
