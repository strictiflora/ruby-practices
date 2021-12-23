# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(scores)
    marks = scores.split(',')
    @frames = devide_into_frames(marks)
  end

  def devide_into_frames(marks)
    frame = []
    frames = []
    marks.each do |mark|
      frame << mark
      # (9フレーム目まで) && (frameが既に2投分の情報を持つ || ストライクのとき)
      if (frames.count < 9) && ((frame.count == 2) || (frame[0] == 'X'))
        frames << frame
        frame = []
      end
    end
    # 10フレーム目を格納
    frames << frame
  end

  def scores
    total = 0
    @frames.each_with_index do |f, i|
      frame = Frame.new(*f)
      next_frame = Frame.new(*@frames[i + 1]) if i < 9

      if frame.strike? && next_frame.strike?
        frame_after_next = Frame.new(*@frames[i + 2])
        total += (frame.score + next_frame.first_shot.score + frame_after_next.first_shot.score)
      elsif frame.strike?
        total += (frame.score + next_frame.first_shot.score + next_frame.second_shot.score)
      elsif frame.spare?
        total += (frame.score + next_frame.first_shot.score)
      else
        total += frame.score
      end
    end
    total
  end
end
