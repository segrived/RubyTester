# encoding: utf-8

class QuestionStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :question
  embedded_in :test_student_assignment
  field :is_answered, type: Boolean, default: false
  field :is_valid_answer, type: Boolean
  field :answered_at, type: DateTime, default: nil
  field :answer, type: String

  scope :answered, -> { where(is_answered: true) }
  scope :unanswered,  -> { where(is_answered: false) }
  scope :has_valid_answer, -> { where(is_valid_answer: true) }
end