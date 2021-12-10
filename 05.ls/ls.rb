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
  columns.map do |column|
    digit = column.max_by(&:length).length
    column.map do |dir_or_file|
      format("%-#{digit}s", dir_or_file) unless dir_or_file == ''
    end
  end
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
  file_mode.chars.map do |char|
    {
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
end

def display_file_details(file_stats, file_nlinks, file_sizes)
  file_stats.each do |file_stat|
    file_types = change_file_type_notation(file_stat[:mode][0, 3])
    file_modes = change_mode_notation(file_stat[:mode][3, 3]).join

    formatted_stat = [
      "#{file_types}#{file_modes} ",
      format("%#{file_nlinks.max.to_s.length}d", file_stat[:nlink]),
      file_stat[:owner],
      file_stat[:group],
      format("%#{file_sizes.max.to_s.length}d", file_stat[:size]),
      file_stat[:timestamp],
      file_stat[:filename]
    ]

    formatted_stat << "-> #{File.readlink(file_stat[:filename].to_s)}" if formatted_stat[0][0] == 'l'
    puts formatted_stat.join(' ')
  end
end

def build_file_stats(file_status, file)
  {
    mode: format('%06d', file_status.mode.to_s(8)),
    nlink: file_status.nlink,
    owner: "#{Etc.getpwuid(file_status.uid).name} ",
    group: "#{Etc.getgrgid(file_status.gid).name} ",
    size: file_status.size,
    timestamp: file_status.mtime.strftime('%_m %e %H:%M'),
    filename: file
  }
end

def ls_long_format(files)
  file_stats = []
  file_nlinks = []
  file_sizes = []
  blocks = 0
  files.each do |file|
    file_status = File.lstat(file)
    file_nlinks << file_status.nlink
    file_sizes << file_status.size
    blocks += file_status.blocks
    file_stats << build_file_stats(file_status, file)
  end

  puts "total #{blocks}" unless files.empty?
  display_file_details(file_stats, file_nlinks, file_sizes)
end

ls(receive_options)
