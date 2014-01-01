class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :name, type: String
  has_many :students

  index({ name: 1 }, { unique: true })
  slug :name

  validates :name, presence: true, uniqueness: true
end
