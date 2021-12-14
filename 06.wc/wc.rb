def adjust_digit(array)
  digit = array.map(&:to_s).max_by(&:length).length
  array.map do |number|
    format("   %#{digit}d", number)
  end
end

if ARGV.empty?
  lines = readlines
  number_of_words = 0
  byte_size = 0
  lines.each do |line|
    byte_size += line.bytesize
    words_per_line = line.split(/\s|\p{blank}/).delete_if {|a| a == ""}.count
    number_of_words += words_per_line
  end

  stdin_info = [lines.count, number_of_words, byte_size]
  puts "      #{stdin_info.join('     ')}"
else
  numbers_of_lines = []
  numbers_of_words = []
  byte_sizes = []
  files = []

  ARGV.each do |file|
    files << file
    byte_sizes << File::Stat.new(file).size
    open(file){ |f|
      lines = f.readlines
      numbers_of_lines << lines.count
      number_of_words = 0
      lines.each do |line|
        words_per_line = line.split(/\s|\p{blank}/).delete_if {|a| a == ""}.count
        number_of_words += words_per_line
      end
      numbers_of_words << number_of_words
    }
  end

  if files.count > 1
    numbers_of_lines << numbers_of_lines.sum
    numbers_of_words << numbers_of_words.sum
    byte_sizes << byte_sizes.sum
    files << 'total'
  end

  [
    adjust_digit(numbers_of_lines),
    adjust_digit(numbers_of_words),
    adjust_digit(byte_sizes),
    files
  ].transpose.each { |file_info| puts "  #{file_info.join(' ')}" }
end
