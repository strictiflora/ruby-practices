# frozen_string_literal: true

require 'etc'

module LS
  class Stat
    def initialize(path)
      @stat = File.lstat(path)
      @path = path
    end

    def mode
      combine_type_with_mode(@stat)
    end

    def nlink
      @stat.nlink
    end

    def owner
      Etc.getpwuid(@stat.uid).name
    end

    def group
      Etc.getgrgid(@stat.gid).name
    end

    def size
      @stat.size
    end

    def timestamp
      @stat.mtime
    end

    def block
      @stat.blocks
    end

    def name
      @path
    end

    def link
      File.readlink(@path) if mode[0] == 'l'
    end

    private

    def combine_type_with_mode(stat)
      mode_in_octal = format('%06d', stat.mode.to_s(8))
      file_type = change_file_type_notation(mode_in_octal[0, 3])
      file_mode = change_mode_notation(mode_in_octal[3, 3]).join
      "#{file_type}#{file_mode}"
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
  end
end
