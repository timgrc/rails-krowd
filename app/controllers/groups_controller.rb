require 'yammer'

class GroupsController < ApplicationController
  before_action :find_group, only: [:show] # :destoy ?

  def index
    @group      = Group.new
    @yam_groups = GetAllGroups.new(current_user.access_token).list
  end

  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = current_user.groups.build(group_params)
    # authorize @group

    if @group.save
      redirect_to group_path(@group)
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
