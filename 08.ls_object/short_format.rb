# frozen_string_literal: true

module LS
  class ShortFormat
    NUM_OF_ROWS = 3

    def initialize(paths)
      @paths = paths
    end

    def adjust_digits(columns)
      columns.map do |column|
        digit = column.max_by(&:length).length
        column.map do |path|
          format("%-#{digit}s", path) unless path == ''
        end
      end
    end

    def display
      files = @paths
      unless (@paths.size % NUM_OF_ROWS).zero?
        (NUM_OF_ROWS - @paths.size % NUM_OF_ROWS).times do
          files += ['']
        end
      end

      columns = []
      unless files.empty?
        files.each_slice(files.size / NUM_OF_ROWS) do |column|
          columns << column
        end
      end

      rows = []
      adjust_digits(columns).transpose.each do |row|
        rows << row.join('      ')
      end

      rows.join("\n")
    end
  end
end
