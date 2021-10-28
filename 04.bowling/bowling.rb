# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  shots << if s == 'X' # strike
             10
           else
             s.to_i
           end
end

@frames = []
arrays = shots.slice_after { |n| n == 10 }.to_a
arrays.each do |arr|
  arr.each_slice(2) do |s|
    @frames << s
  end
end

if @frames[10] && @frames[11]
  @frames[9].concat(@frames[10], @frames[11])
  @frames.delete_at(11)
  @frames.delete_at(10)
elsif @frames[10]
  @frames[9].concat(@frames[10])
  @frames.delete_at(10)
end

point = 0
@frames.each_with_index do |frame, index|
  strike = frame[0] == 10
  third_throw = frame[2]
  sum = frame.sum
  next_frame = @frames[index + 1]
  frame_after_next = @frames[index + 2]
  point += if strike && third_throw
             sum
           elsif strike && !next_frame[1]
             sum + next_frame[0] + frame_after_next[0]
           elsif strike
             sum + next_frame[0] + next_frame[1]
           elsif sum >= 10 && third_throw
             sum
           elsif sum == 10
             sum + next_frame[0]
           else
             sum
           end
end
puts point
