class User < ApplicationRecord
  has_one :academic
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super
  end

  validates :role, presence: true

  enum role: { user: "user", admin: "admin" }

  before_validation :set_default_role

  private
  def set_default_role
    self.role ||= "user"
  end
end
