class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :email, type: String
  field :fname, type: String
  field :lname, type: String
  field :password_digest, type: String

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  validates_presence_of :fname
  validates_presence_of :lname
  
  before_save { self.email = email.downcase }
  before_save { self.fname = fname.titleize }
  before_save { self.lname = lname.titleize }

  has_many :contacts
  has_many :touches
end
