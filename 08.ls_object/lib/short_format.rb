# frozen_string_literal: true

module LS
  class ShortFormat
    NUM_OF_ROWS = 3

    def initialize(paths)
      @paths = paths
    end

    def display
      diff = 0
      diff = (NUM_OF_ROWS - @paths.size % NUM_OF_ROWS) unless (@paths.size % NUM_OF_ROWS).zero?
      blanks = Array.new(diff) { '' }
      paths = [*@paths, *blanks]

      return if paths.empty?

      columns = paths.each_slice(paths.size / NUM_OF_ROWS).to_a
      rows = adjust_digits(columns).transpose.map do |row|
        row.join('      ')
      end
      rows.join("\n")
    end

    private

    def adjust_digits(columns)
      columns.map do |column|
        digit = column.max_by(&:length).length
        column.map do |path|
          format("%-#{digit}s", path) unless path.empty?
        end
      end
    end
  end
end
