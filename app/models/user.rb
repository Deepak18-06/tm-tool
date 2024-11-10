class User < ApplicationRecord
  has_secure_password

  has_many :team_members, dependent: :destroy
  has_many :teams, through: :team_members

  ROLES = { user: 0, admin: 1 }.freeze

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES.values }
  after_initialize :set_default_role, if: :new_record?

  def user?
    role == ROLES[:user]
  end

  def admin?
    role == ROLES[:admin]
  end

  private

  def set_default_role
    self.role ||= ROLES[:user]
  end
end
