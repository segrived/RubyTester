# encoding: utf-8

class QuestionStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  embedded_in :test_attempt
  field :is_answered, type: Boolean, default: false
  field :correctness_level, type: Float, default: 0.0
  field :answered_at, type: DateTime, default: nil
  field :answer, type: String

  scope :answered, -> { where(is_answered: true) }
  scope :unanswered,  -> { where(is_answered: false) }
  scope :correct, -> { where(correctness_level: 1.0) }
  scope :incorrect, -> { where(correctness_level: 0.0) }
  scope :partially_correct, -> {
    where(:correctness_level.gt => 0.0, :correctness_level.lt => 1.0)
  }

  def correctness_in_percent
    (correctness_level * 100).round(2)
  end
end