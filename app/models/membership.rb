class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def destroy
    @membership = Membership.find(params[:id]) #which id will it find ?
    @membership.destroy
  end
    # redirect_to groups_path (will it access from here ?)
end
