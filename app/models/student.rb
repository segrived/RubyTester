class Student
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :fullname, type: String
  index({ fullname: 1 })
  slug :fullname

  belongs_to :group
  has_many :test_attemps

  default_scope order_by(:fullname.asc)

  validates :fullname, presence: true

  def to_s
    fullname
  end
end
