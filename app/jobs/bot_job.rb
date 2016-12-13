class BotJob < ApplicationJob
  queue_as :default

  def perform(*args)
    UseBot.new(BotUser.first).call
  end
end
