# frozen_string_literal: true

require 'optparse'
require_relative 'command'
require_relative 'short_format'
require_relative 'long_format'
require_relative 'path'

opt = OptionParser.new
params = {}
opt.on('-a') { |v| params[:a] = v }
opt.on('-r') { |v| params[:r] = v }
opt.on('-l') { |v| params[:l] = v }
opt.parse!(ARGV)

paths = LS::Path.new(params).paths
long_format = LS::LongFormat.new(paths)
short_format = LS::ShortFormat.new(paths)
ls = LS::Command.new(params, long_format, short_format)
puts ls.execute
