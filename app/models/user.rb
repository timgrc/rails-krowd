class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships
  has_many :groups, through: :memberships

  has_many :user_badges
  has_many :badges, through: :user_badges

  has_many :posts

  has_many :comments

  has_many :incentive_templates

  has_many :push_posts
end
