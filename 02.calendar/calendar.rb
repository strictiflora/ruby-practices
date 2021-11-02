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

first_date.wday.times {print "   "}

(first_date..last_date).each do |i|
  day = i.day
  if i.saturday?
    printf("%2d\n", day)
  elsif day == Date.today.day && date == Date.today
    print day < 7 ? " #{Paint[day, :inverse]} " : "#{Paint[day, :inverse]} "
  else
    printf("%2d%s", day, "\s")
  end
end
