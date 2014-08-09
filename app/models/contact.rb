class Contact
  include Mongoid::Document
  field :fname, type: String
  field :lname, type: String
  field :spouse, type: String
  field :email, type: String
  field :home_phone, type: String
  field :mobile_phone, type: String
  field :address, type: String
  field :giving_level, type: String

  belongs_to :user
  has_many :touches

  def full_name
    "#{fname} #{lname}"
  end

  def lname_fname
    "#{lname}, #{fname}"
  end

end
