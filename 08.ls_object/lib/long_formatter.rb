# frozen_string_literal: true

require_relative 'stat'

module LS
  class LongFormatter
    def initialize(paths)
      @paths = paths
    end

    def display
      stats = @paths.map { |path| LS::Stat.new(path) }

      blocks = stats.map(&:block)
      total = "total #{blocks.sum}"
      [total, format_stats(stats)].join("\n")
    end

    private

    def find_max_digits(stats)
      {
        nlink: stats.max_by(&:nlink).nlink.to_s.length,
        owner: stats.max_by { |stat| stat.owner.length }.owner.length,
        group: stats.max_by { |stat| stat.group.length }.group.length,
        size: stats.max_by(&:size).size.to_s.length
      }
    end

    def format_stats(stats)
      max_digits = find_max_digits(stats)
      stats.map do |stat|
        formatted_stats = [
          "#{stat.mode} ",
          format("%#{max_digits[:nlink]}d", stat.nlink),
          format("%#{max_digits[:owner]}s ", stat.owner),
          format("%#{max_digits[:group]}s ", stat.group),
          format("%#{max_digits[:size]}d", stat.size),
          stat.timestamp.strftime('%_m %e %H:%M'),
          stat.name
        ]

        formatted_stats << "-> #{stat.link}" if stat.link
        formatted_stats.join(' ')
      end
    end
  end
end
