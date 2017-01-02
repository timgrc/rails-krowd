require 'csv'

class InnovationDisruptionThread
  def initialize(message)
    @message = message
  end

  def call
    @message.match(/#(innovation|disruption)/)
  end
end
