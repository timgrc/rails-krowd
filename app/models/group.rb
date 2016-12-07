class Group < ApplicationRecord
  has_many :incentive_templates

  has_many :posts

  has_many :user_badges
  has_many :badges, through: :badges

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  validates :full_name, presence: true

  def member?(user)
    Membership.exists? group: self, user: user
  end
end
