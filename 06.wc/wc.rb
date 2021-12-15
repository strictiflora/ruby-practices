# frozen_string_literal: true

require 'optparse'

def receive_option
  opt = OptionParser.new
  params = {}
  opt.on('-l', '--lines') { params[:l] = true }
  opt.parse!(ARGV)
  params
end

def count(lines)
  word_count = 0
  byte_size = 0

  lines.each do |line|
    byte_size += line.bytesize
    words_per_line = line.split(/\s|\p{blank}/).delete_if { |a| a == '' }.count
    word_count += words_per_line
  end
  ARGV.empty? ? [lines.count, word_count, byte_size] : word_count
end

def store_counts_per_type(files, byte_sizes, numbers_of_lines, word_counts)
  ARGV.each do |file|
    files << file
    byte_sizes << File::Stat.new(file).size
    File.open(file, 'r') do |f|
      lines = f.readlines
      numbers_of_lines << lines.count
      word_counts << count(lines)
    end
  end
end

def adjust_digit(numbers)
  digit = numbers.map(&:to_s).max_by(&:length).length
  numbers.map do |number|
    format("   %#{digit}d", number)
  end
end

def add_total(numbers_of_lines, word_counts, byte_sizes, files)
  numbers_of_lines << numbers_of_lines.sum
  word_counts << word_counts.sum
  byte_sizes << byte_sizes.sum
  files << 'total'
end

def display_file_info(numbers_of_lines, word_counts, byte_sizes, files)
  add_total(numbers_of_lines, word_counts, byte_sizes, files) if ARGV.size > 1
  [
    adjust_digit(numbers_of_lines),
    adjust_digit(word_counts),
    adjust_digit(byte_sizes),
    files
  ].transpose.each { |file_info| puts "  #{file_info.join(' ')}" }
end

def dispay_file_info_with_option_l(numbers_of_lines, word_counts, byte_sizes, files)
  add_total(numbers_of_lines, word_counts, byte_sizes, files) if ARGV.size > 1

  [adjust_digit(numbers_of_lines), files].transpose.each do |file_info|
    puts "  #{file_info.join(' ')}"
  end
end

def wc(params)
  numbers_of_lines = []
  word_counts = []
  byte_sizes = []
  files = []

  store_counts_per_type(files, byte_sizes, numbers_of_lines, word_counts)

  if ARGV.empty?
    lines = readlines
    params[:l] ? puts("      #{lines.count}") : puts("      #{count(lines).join('     ')}")
  elsif ARGV.size > 1 && params[:l]
    dispay_file_info_with_option_l(numbers_of_lines, word_counts, byte_sizes, files)
  elsif ARGV.size > 1
    display_file_info(numbers_of_lines, word_counts, byte_sizes, files)
  elsif params[:l]
    dispay_file_info_with_option_l(numbers_of_lines, word_counts, byte_sizes, files)
  else
    display_file_info(numbers_of_lines, word_counts, byte_sizes, files)
  end
end

wc(receive_option)
