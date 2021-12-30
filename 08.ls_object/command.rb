# frozen_string_literal: true

require 'optparse'

module LS
  class Command
    def initialize(params, long_format, short_format)
      @params = params
      @long_format = long_format
      @short_format = short_format
      @list = short_or_long
    end

    def short_or_long
      @params[:l] ? @long_format : @short_format
    end

    def execute
      @list.display
    end
  end
end
