require 'date'
require 'optparse'
require 'paint'

options = ARGV.getopts('m:y:')
opt_m = options['m']
opt_y = options['y']
month = opt_m.to_i
year = opt_y.to_i

if opt_m && opt_y
  date = Date.new(year, month)
elsif opt_m && !opt_y
  raise OptionParser::MissingArgument
elsif !opt_m && opt_y
  raise OptionParser::MissingArgument
else
  date = Date.today
end

first_date = Date.new(date.year, date.month)
last_date = Date.new(date.year, date.month, -1)

puts "      #{date.month}月 #{date.year}"
puts '日 月 火 水 木 金 土'

days = []
(first_date..last_date).each do |i|
  day = i.day
  days << day
  if i.saturday?
    days << "\n"
  end
end

newline_index = days.index("\n")
#カレンダー1行目が７日より少ない場合に位置を曜日合わせる
arr = []
(7 - newline_index).times do
  arr << "  "
end

print "#{arr.join(' ')} " unless newline_index == 7

days.each do |n|
  if n == "\n"
    print n
  elsif n == Date.today.day && date == Date.today
    print "#{Paint[n, :inverse]} "
  else
    printf("%2d%s", n, "\s")
  end
end
