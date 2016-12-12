require 'yammer'

class GroupsController < ApplicationController
  before_action :find_group, only: [:show] # :destoy ?

  def index
    @groups     = policy_scope(Group)
    @group      = Group.new
    @yam_groups = Yammer::GetAllGroups.new(current_user).call
  end

  def show
    @push_message = PushMessage.new
  end

  def create
    yam_groups            = Yammer::GetAllGroups.new(current_user).call
    group_params_from_api = yam_groups.find do |yam_group|
      yam_group[:full_name] == params[:group][:full_name]
    end
    @group = current_user.groups.build(group_params_from_api)
    authorize @group

    if @group.save
      Membership.create!(user: current_user, group: @group)
      redirect_to groups_path
      # redirect_to group_path(@group)
    else
      # render 'new'
    end
  end

  # def destroy
  # end

  private

  def group_params
    params.require(:group).permit(
      :rse_id,
      :rse_network_id,
      :full_name,
      :description,
      :web_url,
      :mugshot_url
    )
  end

  def find_group
    @group = Group.find(params[:id])
    authorize @group
  end
end
