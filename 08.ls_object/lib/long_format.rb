# frozen_string_literal: true

require_relative 'stat'

module LS
  class LongFormat
    def initialize(paths)
      @paths = paths
    end

    def display
      stats = @paths.map { |path| LS::Stat.new(path) }

      return if @paths.empty?

      blocks = stats.map(&:block)
      total = "total #{blocks.sum}"
      [total, format_stat(stats)].join("\n")
    end

    private

    def find_max_digits(stats)
      {
        'nlink' => stats.map(&:nlink).max.to_s.length,
        'owner' => stats.map(&:owner).max_by(&:length).length,
        'group' => stats.map(&:group).max_by(&:length).length,
        'size' => stats.map(&:size).max.to_s.length
      }
    end

    def format_stat(stats)
      max_digits = find_max_digits(stats)
      stats.map do |stat|
        formatted_stat = [
          "#{stat.mode} ",
          format("%#{max_digits['nlink']}d", stat.nlink),
          format("%#{max_digits['owner']}s ", stat.owner),
          format("%#{max_digits['group']}s ", stat.group),
          format("%#{max_digits['size']}d", stat.size),
          stat.timestamp,
          stat.name
        ]

        formatted_stat << "-> #{stat.link}" if stat.link
        formatted_stat.join(' ')
      end
    end
  end
end
