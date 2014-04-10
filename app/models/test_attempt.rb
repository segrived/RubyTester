# encoding: utf-8

class TestAttempt
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
    return 0 if completed?
    end_time = activate_time + test_session.time_per_student.minutes
    return 0 if end_time < DateTime.now
    ((end_time - DateTime.now) * 24 * 3600).to_i
  end

  def answered_count
    question_statuses.answered.count
  end

  def total_count
    question_statuses.count
  end

  def in_percent(only_answered = false)
    statuses = self.question_statuses
    if only_answered
      statuses = statuses.answered
    end
    total = statuses.count
    return 0.0 if total.zero?
    mul = 100.0 / total
    sum = question_statuses.map(&:correctness_level).inject(&:+)
    (sum * mul).round(2)
  end

  def status
    if completed?
      :completed
    else
      if active?
        :active
      else
        :out_of_time
      end
    end
  end
  
  def answered_percent
    in_percent(only_answered: true)
  end

  def self.find_by_key(key)
    limit(1).where(private_key: key).first
  end

  def as_json(options = {})
    super(
      only: [:student_id],
      methods: [:in_percent, :remains_in_sec, :answered_percent, :status, :answered_count, :total_count]
    )
  end

  private

  def generate_private_key
    self.private_key = SecureRandom.uuid
  end

  def set_activate_time
    self.activate_time = DateTime.now
  end
end