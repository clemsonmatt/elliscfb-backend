class User < ApplicationRecord
  require 'securerandom'

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  def to_s
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name.first}#{last_name.first}"
  end

  def permissions
    roles || 'Role.User'
  end

  def api_details
    {
      id:,
      username:,
      name: self.to_s,
      initials:,
      email:
    }
  end
end
