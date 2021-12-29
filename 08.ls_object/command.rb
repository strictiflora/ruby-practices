# frozen_string_literal: true

require 'optparse'
require_relative 'short_format'
require_relative 'long_format'

module LS
  class Command
    def initialize(params)
      @params = params
      @list = short_or_long
    end

    def short_or_long
      @params[:l] ? LS::LongFormat.new(LS::Path.new(@params).paths) : LS::ShortFormat.new(LS::Path.new(@params).paths)
    end

    def execute
      @list.display
    end
  end
end
