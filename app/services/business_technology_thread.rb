require 'csv'

class BusinessTechnologyThread
  def initialize(message)
    @message = message
  end

  def call
    @message.match(/(#business|#technology)/)
  end
end
