class PushMessagesController < ApplicationController
  before_action :find_group, only: [:create]
  def create
    @push_message = current_user.push_messages.build(push_message_params)
    if @push_message.save
      push
    else
    end
  end

  private

  def push
    congrats_pic = File.open(Rails.root.join("app/assets/images/congrats-transp.png"))
    Yammer::PostMessage.new(current_user, @push_message.body, group_id: @group.rse_id, attachment1: congrats_pic).call
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
