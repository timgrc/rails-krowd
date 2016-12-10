class Yammer::GetTechnipUser
  def initialize(user, user_id)
    @technip_user = user
    @user_id = user_id
  end

  def call
    if TechnipUser.find_by_rse_id(@user_id)
      TechnipUser.find_by_rse_id(@user_id)
    else
      user = Yammer::GetUser.new(@technip_user, @user_id).call
      user[:rse_id] = user[:id]
      user.delete(:id)

      TechnipUser.create(user)
    end
  end
end
