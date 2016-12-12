class Message < ApplicationRecord
  belongs_to :user
  belongs_to :thread_post

  before_save :kind

  private

  def kind
    self.kind = KindOfMessage.new(self.plain).call
  end
end
