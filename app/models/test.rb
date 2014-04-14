# encoding: utf-8

class Test
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :description, type: String
  field :is_archived, type: Boolean, default: false
  field :tags, type: Array
  index({ title: 1 })
  index({ tags: 1 })

  has_many :questions, dependent: :delete
  has_many :test_sessions, dependent: :delete

  scope :archived, -> { where(is_archived: true) }
  scope :unarchived, -> { where(is_archived: false) }

  validates :title, presence: true, length: { minimum: 2 }
  before_save :process_tags

  def process_tags
    self.tags = self.tags.split(',').map(&:strip)
  end

  def tags_str
    self.tags.any? ? self.tags.join(", ") : "отсутствуют"
  end

  def self.top_tags(count = 20)
    Test.collection.aggregate([
      { "$unwind"  => "$tags" },
      { "$group"   => { _id: "$tags", weight: { "$sum" => 1 } } },
      { "$project" => { _id: 0, tag: "$_id", weight: "$weight" } },
      { "$sort"    => { weight: -1 } },
      { "$limit"   => count }
    ]).map {|e| e["tag"]}
  end
end
