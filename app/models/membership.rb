class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def destroy
    Membership.find(params[:id]), params[:id].delete
  end
end
