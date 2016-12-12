class Yammer::GetUser
  def initialize(user, user_id)
    @yam        = Yammer::Client.new(access_token: user.access_token)
    @user_id = user_id
  end

  def call
    if User.find_by_rse_id(@user_id)
      User.find_by_rse_id(@user_id)

    else
      user = @yam.get_user(@user_id).body
      user_keys_needed = [
        :id,
        :email,
        :job_title,
        :location,
        :expertise,
        :first_name,
        :last_name,
        :name,
        :mugshot_url_template,
        :timezone,
        :department,
        :contact,
        :network_name
      ]

      user = user.select { |key, _| user_keys_needed.include? key }
      user[:rse_id] = user[:id]
      user.delete(:id)

      user[:mugshot_url] = user[:mugshot_url_template].sub('{width}x{height}','400x400')
      user.delete(:mugshot_url_template)

      user[:username] = user[:name]
      user.delete(:name)

      user[:password] = (0...8).map { (65 + rand(26)).chr }.join

      User.create!(user)
    end
  end
end
