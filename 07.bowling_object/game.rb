# frozen_string_literal: true

require_relative 'frame'

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
        frames << Frame.new(*frame)
        frame = []
      end
    end
    # 10フレーム目を格納
    frames << Frame.new(*frame)
  end

  def calculate_score
    @frames.each_with_index.sum do |frame, i|
      next_frame = @frames[i + 1] if i < 9

      if frame.strike? && next_frame.strike?
        frame.score + next_frame.first_shot.score + @frames[i + 2].first_shot.score
      elsif frame.strike?
        frame.score + next_frame.first_shot.score + next_frame.second_shot.score
      elsif frame.spare?
        frame.score + next_frame.first_shot.score
      else
        frame.score
      end
    end
  end
end
