# frozen_string_literal: true

require 'optparse'

NUM_OF_ROWS = 3

def receive_option(params)
  opt = OptionParser.new
  opt.on('-a', '--all', 'Include directory entries whose names begin with a dot') { |v| params[:a] = v }
  opt.parse!(ARGV)
end

def adjust_digits(columns)
  columns.each do |column|
    column.map! do |dir_or_file|
      digit = column.max_by(&:length).length
      format("%-#{digit}s", dir_or_file) unless dir_or_file == ''
    end
  end
end

def display_columns(columns)
  columns.transpose.each do |row|
    puts row.join('      ')
  end
end

def ls
  params = {}
  receive_option(params)

  dirs_and_files = if params[:a]
                     Dir.glob('*', File::FNM_DOTMATCH)
                   else
                     Dir.glob('*')
                   end

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

ls
