# bcrypt is the password hash generator
require 'bcrypt'

class User
  include DataMapper::Resource

  validates_confirmation_of :password
  validates_uniqueness_of :email

  attr_reader :password
  attr_accessor :password_confirmation
  # validates_confirmation_of is a DataMapper method
# provided especially for validating confirmation passwords!
# The model will not save unless both password
# and password_confirmation are the same
# read more about it in the documentation
# http://datamapper.org/docs/validations.html


  property :id, Serial
  property :email, String, required: true
  # this will store both the password and the salt
  # It's Text and not String because String holds
  # 50 characters by default
  # and it's not enough for the hash and salt!!!
  property :password_digest, Text
  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by bcrypt,
  # has both the password hash and the salt. We save it to the
  # database instead of the plain password for security reasons.
  def password=(password)  # AV where/when is this method called?
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = User.first(email: email)
    #BCrypt::Password.authenticate(self.password_digest)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end
end
