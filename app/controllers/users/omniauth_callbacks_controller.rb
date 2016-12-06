class Users::OmniauthCallbacksController < ApplicationController
  require 'yammer'

  skip_before_action :authenticate_user!

  def yammer
    yammer_client = Yammer::OAuth2Client.new(ENV['YAMMER_ID'], ENV['YAMMER_SECRET'])
    auth_url = yammer_client.webserver_authorization_url
    redirect_to auth_url
  end

  def callback
    yammer_client = Yammer::OAuth2Client.new(ENV['YAMMER_ID'], ENV['YAMMER_SECRET'])
    res = yammer_client.access_token_from_authorization_code(params[:code])
    user = User.find_for_yammer_oauth(JSON.parse(res.body))
    flash[:notice] = "Successfully authenticated from Yammer"
    sign_in_and_redirect(user)
  end
end
