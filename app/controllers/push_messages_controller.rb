class PushMessagesController < ApplicationController
  before_action :find_group, only: [:create]
  def create
    @push_message = current_user.push_messages.build(push_message_params)
    if @push_message.save
      push
      redirect_to group_path(@group)
    else
      # render ''
    end
  end

  private

  def push
    Yammer::PostMessage.new(current_user, @push_message.body, group_id: @group.rse_id).call
  end

  def push_message_params
    params.require(:push_message).permit(
      :body
    )
  end

  def find_group
    @group = Group.find(params[:group_id])
    authorize @group
  end
end
