class Group < ApplicationRecord
  has_many :incentive_templates

  has_many :posts

  has_many :user_badges
  has_many :badges, through: :badges

  has_many :memberships
  has_many :users, through: :memberships

  validates :full_name, presence: true
end
