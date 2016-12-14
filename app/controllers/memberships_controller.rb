class MembershipsController < ApplicationController
  skip_after_action :verify_policy_scoped

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
  end
end
