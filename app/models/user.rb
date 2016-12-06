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

  def self.find_for_yammer_oauth(auth)
    user_params = {
      access_token: auth["access_token"]["token"],
      rse_user_id: auth["access_token"]["user_id"],
      email: auth["user"]["email"],
      username: auth["user"]["name"],
      first_name: auth["user"]["first_name"],
      last_name: auth["user"]["last_name"],
      job_title: auth["user"]["job_ttle"],
      contact: auth["user"]["contact"],
      timezone: auth["user"]["timezone"],
      location: auth["user"]["location"],
      department: auth["user"]["department"],
      expertise: auth["user"]["expertise"],
      mugshot_url: auth["user"]["mugshot_url_template"].sub('{width}x{height}','400x400'),
      network_name: auth["user"]["network_name"]
    }

    user = User.where(email: auth["user"]["email"]).first

    if user
      # User already signed up -> update data?
      user.update(user_params)
    else
      # User does not not exists, we create it
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20]
      user.save
    end

    return user
  end
end
