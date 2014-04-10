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

  def correctness_in_percent
    (correctness_level * 100).round(2)
  end
end