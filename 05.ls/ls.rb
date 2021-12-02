# frozen_string_literal: true

require 'optparse'
require 'etc'

NUM_OF_ROWS = 3

def receive_options
  opt = OptionParser.new
  params = {}
  opt.on('-l', '--long', 'List in long format.') { |v| params[:l] = v }
  opt.parse!(ARGV)
  params
end

def adjust_digits(columns)
  adjusted_columns = []
  columns.each do |column|
    digit = column.max_by(&:length).length
    adjusted_columns << column.map do |dir_or_file|
      format("%-#{digit}s", dir_or_file) unless dir_or_file == ''
    end
  end
  adjusted_columns
end

def ls_without_options(files)
  unless (files.size % NUM_OF_ROWS).zero?
    (NUM_OF_ROWS - files.size % NUM_OF_ROWS).times do
      files << ''
    end
  end

  columns = []
  unless files.empty?
    files.each_slice(files.size / NUM_OF_ROWS) do |column|
      columns << column
    end
  end

  adjust_digits(columns).transpose.each do |row|
    puts row.join('      ')
  end
end

def ls(params)
  files = Dir.glob('*', sort: true)
  params[:l] ? ls_long_format(files) : ls_without_options(files)
end

def change_file_type_notation(file_type)
  {
    '010' => 'p',
    '020' => 'c',
    '040' => 'd',
    '060' => 'b',
    '100' => '-',
    '120' => 'l',
    '140' => 's'
  }[file_type]
end

def change_mode_notation(file_mode)
  mode = []
  file_mode.each_char do |char|
    mode << {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }[char]
  end
  mode.join
end

def display_file_details(files_with_stat, file_nlinks, file_sizes)
  files_with_stat.each do |file_with_stat|
    file_types = change_file_type_notation(file_with_stat[0][0, 3])
    file_modes = change_mode_notation(file_with_stat[0][3, 3])

    file_with_formatted_stat = [
      "#{file_types}#{file_modes} ",
      format("%#{file_nlinks.max.to_s.length}d", file_with_stat[1]),
      file_with_stat[2],
      file_with_stat[3],
      format("%#{file_sizes.max.to_s.length}d", file_with_stat[4]),
      file_with_stat[5],
      file_with_stat[6]
    ]

    file_with_formatted_stat << "-> #{File.readlink(file_with_stat[6].to_s)}" if file_with_formatted_stat[0][0] == 'l'
    puts file_with_formatted_stat.join(' ')
  end
end

def store_file_status(file_status, file)
  [
    format('%06d ', file_status.mode.to_s(8)),
    file_status.nlink,
    "#{Etc.getpwuid(file_status.uid).name} ",
    "#{Etc.getgrgid(file_status.gid).name} ",
    file_status.size,
    file_status.mtime.strftime('%_m %e %H:%M'),
    file
  ]
end

def ls_long_format(files)
  files_with_stat = []
  file_nlinks = []
  file_sizes = []
  blocks = 0
  files.each do |file|
    file_status = File.lstat(file)
    file_nlinks << file_status.nlink
    file_sizes << file_status.size
    blocks += file_status.blocks
    files_with_stat << store_file_status(file_status, file)
  end

  puts "total #{blocks}" unless files.empty?
  display_file_details(files_with_stat, file_nlinks, file_sizes)
end

ls(receive_options)
