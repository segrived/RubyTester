# encoding: utf-8

class TestSession
  include Mongoid::Document
  include Mongoid::Timestamps

  field :description, type: String
  field :questions_count, type: Integer
  field :max_points, type: Integer
  field :time_per_student, type: Integer
  field :end_time, type: DateTime
  field :report_correct_status, type: Boolean, default: false
  belongs_to :test
  belongs_to :group
  has_many :test_student_assignments, dependent: :delete
  
  # Активной считается та сессия, которая ещё не окончена, либо не имеет даты завершения
  scope :active, -> { any_of({:end_time.gt => Time.now}, {:end_time => nil}) }
  scope :inactive, -> { where(:end_time.lte => Time.now) }

  attr_accessor :session_length

  before_save :set_end_time

  index({ end_time: -1 })

  validates :questions_count,
    numericality: { greater_than: 0, less_than_or_equal_to: :total_questions_count },
    presence: true
  validates :session_length, numericality: { greater_than_or_equal_to: 0 }
  validates :time_per_student, numericality: { greater_than: 0 }
  validate :check_test_archived_state
  
  def remains_in_sec
    return 0 if self.end_time < Time.now || self.end_time.nil?
    ((self.end_time - DateTime.now) * 24 * 3600).to_i
  end

  private

  def set_end_time
    self.session_length = self.session_length.to_i
    if self.session_length != 0
      self.end_time = Time.now + self.session_length.minutes
    end
  end

  def total_questions_count
    test.questions.count
  end

  def check_test_archived_state
    if test.is_archived
      errors.add(:base, "Тест заархивирован, использование его для тестирования недопустимо")
    end
  end
end
