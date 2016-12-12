require 'csv'

class InnovationDisruptionThread
  def initialize(message, topics)
    @message = message
    @topics  = topics
  end

  def call
    innovation_disruption = {
      innovation: ['Post2', 'Post13', 'Post14', 'Post22'],
      disruption: ['Post4', 'Post10', 'Post15', 'Post24']
    }

    innovation_disruption.each do |key, posts|
      posts.each do |post|
        return key.to_s if @message.match(/#{post} /)
      end
    end

    return 'disruption' if @topics.include? 'disruption'
    return 'innovation' if @topics.include? 'innovation'

    'innovation'
  end
end
