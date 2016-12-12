class Message < ApplicationRecord
  belongs_to :user
  belongs_to :thread_post

  before_save :kind

  private

  def kind
    self.idea_kint_kext_social = KindOfMessage.new(self.plain).call
  end
end
