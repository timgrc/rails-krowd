require 'csv'

class BusinessTechnologyThread
  def initialize(message, topics)
    @message = message
    @topics  = topics
  end

  def call
    business_technology = {
      business:   ['Post24', 'Post13', 'Post10', 'Post2'],
      technology: ['Post22', 'Post15', 'Post14', 'Post4']
    }

    business_technology.each do |key, posts|
      posts.each do |post|
        return key.to_s if @message.match(/#{post} /)
      end
    end

    return 'technology' if @topics.include? 'technology'
    return 'business' if @topics.include? 'business'

    'technology'
  end
end
