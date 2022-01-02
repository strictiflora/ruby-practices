# frozen_string_literal: true

module LS
  class Command
    def initialize(params, long_format, short_format)
      @params = params
      @long_format = long_format
      @short_format = short_format
      @list = short_or_long
    end

    def execute
      @list.display
    end

    private

    def short_or_long
      @params[:l] ? @long_format : @short_format
    end
  end
end
