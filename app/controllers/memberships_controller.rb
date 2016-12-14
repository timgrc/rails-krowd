class MembershipsController < ApplicationController
  def destroy
    @membership = Membership.find(params[:id])
    authorize @membership
    if @membership.destroy
     respond_to do |format|
        format.html { redirect_to membership_path(@membership) }
        format.js
      end
    else
      respond_to do |format|
        format.html {redirect_to groups}
        format.js
      end
    end
  end
end
