class Team < ApplicationRecord
  has_many :team_members, dependent: :destroy
  has_many :users, through: :team_members
  belongs_to :owner, class_name: "User"

  validates :name, :description, :owner, presence: true
end
