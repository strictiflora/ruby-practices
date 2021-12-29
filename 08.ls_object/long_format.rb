# frozen_string_literal: true

require 'etc'
require_relative 'path'

module LS
  class LongFormat
    def initialize(paths)
      @paths = paths
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
      nlinks_digit = file_nlinks.max.to_s.length
      sizes_digit = file_sizes.max.to_s.length

      file_stats.each do |file_stat|
        file_types = change_file_type_notation(file_stat[:mode][0, 3])
        file_modes = change_mode_notation(file_stat[:mode][3, 3]).join

        formatted_stat = [
          "#{file_types}#{file_modes} ",
          format("%#{nlinks_digit}d", file_stat[:nlink]),
          file_stat[:owner],
          file_stat[:group],
          format("%#{sizes_digit}d", file_stat[:size]),
          file_stat[:timestamp],
          file_stat[:filename]
        ]

        formatted_stat << "-> #{File.readlink(file_stat[:filename].to_s)}" if formatted_stat[0][0] == 'l'
        puts formatted_stat.join(' ')
      end
    end

    def build_stats(file_status, file)
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

    def display
      file_stats = []
      file_nlinks = []
      file_sizes = []
      blocks = 0
      @paths.each do |path|
        fs = File.lstat(path)
        file_nlinks << fs.nlink
        file_sizes << fs.size
        blocks += fs.blocks
        file_stats << build_stats(fs, path)
      end

      puts "total #{blocks}" unless @paths.empty?
      display_file_details(file_stats, file_nlinks, file_sizes)
    end
  end
end
