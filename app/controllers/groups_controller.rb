require 'yammer'

class GroupsController < ApplicationController
  before_action :find_group, only: [:show] # :destoy ?

  def index
    @groups     = Group.all
    @group      = Group.new
    @yam_groups = GetAllGroups.new(current_user.access_token).list
  end

  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    # authorize @group
  end

  def create
    yam_groups            = GetAllGroups.new(current_user.access_token).list
    group_params_from_api = yam_groups.find do |yam_group|
      yam_group[:full_name] == params[:group][:full_name]
    end
    @group = current_user.groups.build(group_params_from_api)
    # authorize @group

    if @group.save
      # redirect_to group_path(@group)
      redirect_to groups_path
    else
      render 'new'
    end
  end

  # def destroy
  # end

  private

  def group_params
    params.require(:group).permit(
      :rse_group_id,
      :rse_network_id,
      :full_name,
      :description,
      :web_url,
      :mugshot_url
    )
  end

  def find_group
    @group = Group.find(params[:id])
    # authorize @group
  end
end
