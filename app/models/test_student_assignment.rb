# encoding: utf-8

class TestStudentAssignment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :private_key, type: String
  field :activate_time, type: DateTime
  embeds_many :question_statuses
  belongs_to :test_session, index: true
  belongs_to :student, index: true

  before_save :generate_private_key
  before_save :set_activate_time

  index({ private_key: 1 }, {unique: true})
  index({ test_session_id: 1, student_id: 1 }, { unique: true })

  def completed?
    !question_statuses.where(is_answered: false).exists?
  end

  def active?
    remains_in_sec > 0
  end

  def remains_in_sec
    end_time = activate_time + test_session.time_per_student.minutes
    return 0 if end_time < DateTime.now
    ((end_time - DateTime.now) * 24 * 3600).to_i
  end

  def answered_count
    question_statuses.where(is_answered: true).count
  end

  def in_percent
    total = self.question_statuses.count
    return 0.0 if total.zero?
    mul = 100.0 / total
    sum = question_statuses.map(&:correctness_level).inject(&:+)
    sum * mul
  end
  
  def self.find_by_key(key)
    limit(1).where(private_key: key).first
  end

  private

  def generate_private_key
    self.private_key = SecureRandom.uuid
  end

  def set_activate_time
    self.activate_time = DateTime.now
  end
end