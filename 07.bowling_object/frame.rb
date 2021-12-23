# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  STRIKE = 10
  SPARE = 10

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [first_shot.score, second_shot.score, third_shot.score].sum
  end

  def strike?
    first_shot.score == STRIKE && second_shot.mark.nil? && third_shot.mark.nil?
  end

  def spare?
    !strike? && [first_shot.score, second_shot.score].sum == SPARE && third_shot.mark.nil?
  end
end
