class MembershipsController < ApplicationController
  skip_after_action :verify_authorized

  def destroy
    @membership = current_user.memberships.find(params[:id])
    @membership.user_in_dash = false
    @membership.save
  end
end
