class GroupsController < ApplicationController
  before_action :find_group, only: [:show, :create] # :destoy ?

  # def index # do we have an index ?
  #   @groups = policy_scope(Group)
  # end

  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = current_user.groups.build(group_params)
    authorize @group

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
    params.require(:group).permit(:full_name)
  end

  def find_group
    @group = Group.find(params[:id])
    authorize @group
  end
end
