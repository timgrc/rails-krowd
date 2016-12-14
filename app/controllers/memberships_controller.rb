class MembershipsController < ApplicationController
  def destroy
    @membership = Membership.find(params[:id])
    authorize @membership
    @membership.destroy
  end
end
