class User
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

  field :login, type: String
  field :password_hash, type: String
  field :password_salt, type: String
  field :permissions, type: Array
  field :fullname, type: String

  has_many :test_sessions

  attr_accessor :password, :permissions_hash

  # filters
  before_validation :extract_permissions
  before_save :encrypt_password

  index({ login: 1 }, { unique: true, name: "login_index" })
  slug :login

  PERMISSIONS = %w[ canLogin canAdmin canManageTests canUseTests canBrowseReports canManageStudents ]

  def can?(action)
    return nil unless permissions
    permissions.include? "can#{action.ucfirst}"
  end

  PERMISSIONS.each do |perm|
    method_name = perm.gsub(/([A-Z])/) {|s| "_#{s.downcase}"}
    define_method("#{method_name}?") { permissions.include? perm  }
  end

  validates :login, presence: true,
    length: { minimum: 2 }, format: { with: /\A[a-z0-9_]+\Z/i }, uniqueness: true
  validates :permissions, enum: { presence: true, inclusion: { in: PERMISSIONS } }

  def self.authenticate(login, password)
    user = User.where(login: login).first
    return nil unless user
    ph, ps = user.password_hash, user.password_salt
    (ph == BCrypt::Engine.hash_secret(password, ps)) ? user : nil
  end

  private

  def extract_permissions
    if permissions_hash.present?
      self.permissions = permissions_hash.reject {|k, v| v.to_i.zero? }.keys
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
      password = password_confirmation = nil
    end
  end
end
