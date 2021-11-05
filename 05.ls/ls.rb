# frozen_string_literal: true

def adjust_digits(columns, max_length_of_column)
  columns.each_with_index do |column, index|
    column.map! do |dir_or_file|
      digit = max_length_of_column["column#{index + 1}"]
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
  dirs_and_files = Dir.glob("*")
  num_of_rows = 3
  (num_of_rows - dirs_and_files.size % num_of_rows).times { dirs_and_files << '' } unless (dirs_and_files.size % num_of_rows).zero?

  columns = []
  max_length_of_column = {}
  dirs_and_files.each_slice(dirs_and_files.size / num_of_rows).with_index do |column, index|
    columns << column
    max_length_of_column["column#{index + 1}"] = column.max_by(&:length).length
  end

  adjust_digits(columns, max_length_of_column)
  display_columns(columns)
end
ls
