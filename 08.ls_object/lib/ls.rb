# frozen_string_literal: true

require 'optparse'
require_relative 'short_formatter'
require_relative 'long_formatter'

opt = OptionParser.new
params = {}
opt.on('-a') { |v| params[:a] = v }
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

paths = params[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
paths = paths.reverse if params[:r]
format = params[:l] ? LS::LongFormatter.new(paths) : LS::ShortFormatter.new(paths)
puts format.display
