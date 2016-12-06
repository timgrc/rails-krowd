class Badge < ApplicationRecord
  has_many :user_badges
  has_many :users, through: :user_badges

  validates :name, presence: true, uniqueness: true
  validates :kind, presence: true, uniqueness: true
end
