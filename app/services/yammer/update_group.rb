require 'yammer'

class Yammer::UpdateGroup
  def initialize(user, group)
    @yam   = Yammer::Client.new(access_token: user.access_token)
    @group = group
  end

  def call
    puts "-- Update start --"

    get_all_thread_posts_rse_id
    update_thread_posts
    save_messages_in_db

    puts '-- Update finished - 100% Good Style --'
  end

  def get_all_thread_posts_rse_id
    @new_thread_posts_rse_id = []
    opts                     = {threaded: true}
    up_to_date               = false

    begin
      thread_posts = @yam.messages_in_group(@group.rse_id, opts).body[:messages]
      thread_posts.each do |thread_post|
        if ThreadPost.where(rse_id: thread_post[:id])
          up_to_date = true
          break
        end
        @new_thread_posts_rse_id.push thread_post[:id]
      end
      opts[:older_than] = thread_posts.last[:id] unless thread_posts.empty?
    end until thread_posts.empty? || up_to_date

    sleep(5)
    @new_thread_posts_rse_id
  end

  def update_thread_posts
    @all_thread_posts_rse_id.each do |thread_post_rse_id|

      if ThreadPost.where(rse_id: thread_post_rse_id).empty?
        thread_post_fetched = @yam.get_thread(thread_post_rse_id)

        @thread_post = ThreadPost.new(thread_post_fetched[:id])

        qualify_thread
        get_thread_sender
        @thread_post.user = @thread_sender
        @thread_post.group = @group
        @thread_post.save

      else
        @thread_post = ThreadPost.find_by_rse_id(thread_post_rse_id)
      end

      get_new_messages_id_from_thread
    end
  end

  def qualify_thread
    first_reply = Yammer::GetMessage.new(@yam, @thread_post.rse_id).call

    innovation_disruption = InnovationDisruptionThread.new(first_reply[:plain]).call
    business_technology   = BusinessTechnologyThread.new(first_reply[:plain]).call

    @thread_post.innovation_disruption = innovation_disruption[1] if innovation_disruption.nil?
    @thread_post.business_technology   = business_technology[1] if business_technology.nil?
  end

  def get_thread_sender
    if User.where(rse_id: @thread_post[:sender_id]).empty?
      @thread_sender = Yammer::GetUser.new(@yam, thread[:sender_id]).call
    else
      @thread_sender = User.find_by_rse_id(@thread_post[:sender_id])
    end
  end

  def get_new_messages_from_thread
    @new_messages_rse_ids = []
    opts = {}
    up_to_date = false

    begin
      messages_in_thread = @yam.messages_in_thread(@thread_post.rse_id, opts).body[:messages]
      messages_in_thread.each do |message_in_thread|
        if Message.where(rse_id: message_in_thread[:id])
          up_to_date = true
          break
        end
        @new_messages_rse_ids.push message_in_thread[:id]
      end
      opts[:older_than] = messages_in_thread.last[:id] unless messages_in_thread.empty?
    end until messages_in_thread.empty? || up_to_date

    sleep(5)
    @new_messages_rse_ids
  end

  def save_messages_in_db
    puts "-- #{@new_messages_rse_ids.count} Messages to fetch --"
    @new_messages_rse_ids.reverse.each_with_index do |message_id, index|
      get_message(message_id)
      get_likes(message_id)

      new_message = Message.new(@message)
      message_sender = Yammer::GetUser.new(@yam, @message_fetched[:sender_id]).call

      new_message.thread_post = ThreadPost.find_by_rse_id(@message_fetched[:thread_id])
      new_message.replied_to_id = Message.where(rse_replied_to_id: @message_fetched[:replied_to_id])
      new_message.user = message_sender
      new_message.save

      puts "#{index + 1} / #{@new_messages_rse_ids.count}"
      sleep(5)
    end
  end

  def get_message(message_id)
    @message_fetched = @yam.get_message(message_id).body

    @message = {
      rse_id:            @message_fetched[:id],
      rse_replied_to_id: @message_fetched[:replied_to_id],
      web_url:           @message_fetched[:web_url],
      plain:             @message_fetched[:body][:plain],
      parsed:            @message_fetched[:body][:parsed],
      notified_by:       @message_fetched[:notified_user_ids].count,
    }
  end

  def get_likes(message_id)
    @message[:liked_by] = @yam.get("/api/v1/users/liked_message/#{message_id}.json").body[:users].count
  end
end
