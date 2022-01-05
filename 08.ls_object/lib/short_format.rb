# frozen_string_literal: true

module LS
  class ShortFormatter
    NUM_OF_COLUMNS = 3.0

    def initialize(paths)
      @paths = paths
    end

    def display
      num_of_rows = (@paths.size / NUM_OF_COLUMNS).ceil
      columns = @paths.each_slice(num_of_rows).to_a
      columns = adjust_digits(columns).map { |column| column.values_at(0...num_of_rows) }
      rows = columns.transpose.map do |row|
        row.join('      ')
      end
      rows.join("\n")
    end

    private

    def adjust_digits(columns)
      columns.map do |column|
        digit = column.max_by(&:length).length
        column.map do |path|
          format("%-#{digit}s", path)
        end
      end
    end
  end
end
