# encoding: utf-8

class Test
  include Mongoid::Document
  include Mongoid::Taggable
  include Mongoid::Timestamps

  # on document remove we need to rebiuld tag index
  after_destroy :save_tags_index!

  tags_separator ','

  field :title, type: String
  field :description, type: String
  field :is_archived, type: Boolean, default: false

  has_many :questions, dependent: :delete
  has_many :test_sessions, dependent: :delete
  
  index({ tags_array: 1 })

  scope :archived, ->() { where(is_archived: true) }
  scope :unarchived, ->() { where(is_archived: false) }

  validates :title, presence: true, length: { minimum: 2 }

  def tags_str
    self.tags_array.any? ? self.tags_array.join(", ") : "отсутствуют"
  end
end
