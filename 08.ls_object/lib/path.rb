# frozen_string_literal: true

module LS
  class Path
    attr_reader :paths

    def initialize(params)
      @params = params
      @paths = dotmatch_or_not
      @paths = reverse_or_not
    end

    private

    def dotmatch_or_not
      @params[:a] ? Dir.glob('*', File::FNM_DOTMATCH, sort: true) : Dir.glob('*', sort: true)
    end

    def reverse_or_not
      @params[:r] ? paths.reverse : paths
    end
  end
end
