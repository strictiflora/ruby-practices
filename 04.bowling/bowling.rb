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

frames = []
arrays_sliced_after_strike = shots.slice_after { |n| n == 10 }.to_a
arrays_sliced_after_strike.each do |arr|
  arr.each_slice(2) do |s|
    frames << s
  end
end

frames << frames.slice!(9..).flatten

point = 0
frames.each_with_index do |frame, index|
  strike = frame[0] == 10
  frame_sum = frame.sum
  next_frame = frames[index + 1]
  frame_after_next = frames[index + 2]
  point += if frame.size == 3
             frame_sum
           elsif strike && next_frame.size == 1
             frame_sum + next_frame[0] + frame_after_next[0]
           elsif strike
             frame_sum + next_frame[0] + next_frame[1]
           elsif frame_sum == 10
             frame_sum + next_frame[0]
           else
             frame_sum
           end
end
puts point
