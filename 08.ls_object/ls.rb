# frozen_string_literal: true

require_relative 'command'

def receive_options
  opt = OptionParser.new
  params = {}
  opt.on('-a', '--all', 'Include directory entries whose names begin with a dot') { |v| params[:a] = v }
  opt.on('-r', '--reverse', 'Reverse the order') { |v| params[:r] = v }
  opt.on('-l', '--long', 'List in long format.') { |v| params[:l] = v }
  opt.parse!(ARGV)
  params
end

ls = LS::Command.new(receive_options)
ls.execute
