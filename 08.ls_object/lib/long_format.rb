# frozen_string_literal: true

require_relative 'stat'

module LS
  class LongFormat
    def initialize(paths)
      @paths = paths
    end

    def display
      stats = []
      nlinks = []
      owners = []
      groups = []
      sizes = []
      blocks = 0
      @paths.each do |path|
        stat = LS::Stat.new(path)
        nlinks << stat.nlink
        owners << stat.owner
        groups << stat.group
        sizes << stat.size
        blocks += stat.block
        stats << build_data(stat)
      end

      unless @paths.empty?
        total = "total #{blocks}"
        formatted_stats = format_stat(stats, nlinks, owners, groups, sizes)
      end
      [total, formatted_stats].join("\n")
    end

    private

    def build_data(stat)
      data = {
        mode: stat.mode,
        nlink: stat.nlink,
        owner: stat.owner,
        group: stat.group,
        size: stat.size,
        timestamp: stat.timestamp,
        name: stat.name
      }
      data[:link] = "-> #{stat.link}" if stat.link
      data
    end

    def find_max_digits(nlinks, owners, groups, sizes)
      {
        'nlink' => nlinks.max.to_s.length,
        'owner' => owners.max_by(&:length).length,
        'group' => groups.max_by(&:length).length,
        'size' => sizes.max.to_s.length
      }
    end

    def format_stat(stats, nlinks, owners, groups, sizes)
      max_digit = find_max_digits(nlinks, owners, groups, sizes)
      formatted_stats = []
      stats.each do |stat|
        formatted_stat = [
          "#{stat[:mode]} ",
          format("%#{max_digit['nlink']}d", stat[:nlink]),
          format("%#{max_digit['owner']}s ", stat[:owner]),
          format("%#{max_digit['group']}s ", stat[:group]),
          format("%#{max_digit['size']}d", stat[:size]),
          stat[:timestamp],
          stat[:name]
        ]

        formatted_stat << stat[:link] if stat.key?(:link)
        formatted_stats << formatted_stat.join(' ')
      end
      formatted_stats
    end
  end
end
