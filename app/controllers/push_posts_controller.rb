class PushPostsController < ApplicationController
  before_action :find_group, only: [:create]
  def create
    @push_post = current_user.push_posts.build(push_post_params)
    if @push_post.save
      push
      redirect_to group_path(@group)
    else
      # render ''
    end
  end

  private

  def push
    # raise
  end

  def push_post_params
    params.require(:push_post).permit(
      :title,
      :body
    )
  end

  def find_group
    @group = Group.find(params[:group_id])
    authorize @group
  end
end
