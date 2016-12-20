class PushMessagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:bot_answer]
  skip_before_action :authenticate_user!, only: [:bot_answer]
  skip_after_action :verify_authorized, only: [:bot_answer]
  before_action :find_group, only: [:create]

  def create
    @push_message = current_user.push_messages.build(push_message_params)
    if @push_message.save
      push
    end
  end

  def bot_answer
    PushBotAnswer.new(BotUser.first, bot_question_params).call
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

  def bot_question_params
    params.permit(
      :id,
      :sender_id,
      :plain,
      :first_name
    )
  end

  def find_group
    @group = Group.find(params[:group_id])
    authorize @group
  end
end
