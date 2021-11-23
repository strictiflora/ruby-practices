# frozen_string_literal: true

require 'optparse'

NUM_OF_ROWS = 3

def receive_options
  opt = OptionParser.new
  params = {}
  opt.on('-r', '--reverse', 'reverse') { |v| params[:r] = v }
  opt.parse!(ARGV)
  params
end

def adjust_digits(columns)
  columns.each do |column|
    digit = column.max_by(&:length).length
    column.map! do |dir_or_file|
      format("%-#{digit}s", dir_or_file) unless dir_or_file == ''
    end
  end
end

def display_columns(columns)
  columns.transpose.each do |row|
    puts row.join('      ')
  end
end

def ls(params)
  dirs_and_files = Dir.glob('*')

  dirs_and_files.sort!
  dirs_and_files.reverse! if params[:r]

  unless (dirs_and_files.size % NUM_OF_ROWS).zero?
    (NUM_OF_ROWS - dirs_and_files.size % NUM_OF_ROWS).times do
      dirs_and_files << ''
    end
  end

  columns = []
  dirs_and_files.each_slice(dirs_and_files.size / NUM_OF_ROWS) do |column|
    columns << column
  end

  adjust_digits(columns)
  display_columns(columns)
end

ls(receive_options)
