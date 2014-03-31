class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :name, type: String
  has_many :students, dependent: :delete

  index({ name: 1 }, { unique: true })
  slug :name

  validates :name, presence: true, uniqueness: true
end
