require 'yammer'

class Yammer::UpdateGroup
  def initialize(user, group)
    @yam   = Yammer::Client.new(access_token: user.access_token)
    @user  = user
    @group = group
    @new_messages_rse_ids = []

    timer_count = {
      timer: Time.now,
      count: 0
    }
    @count_api_limits = {
      user:    timer_count.dup,
      thread:  timer_count.dup,
      message: timer_count.dup
    }
  end

  def call
    puts "-- Update start --"

    thread_posts_rse_id = get_all_thread_posts_rse_id
    puts "#{thread_posts_rse_id.count} new threads to fetch"

    update_thread_posts

    @new_messages_rse_ids.flatten!

    save_messages_in_db

    puts '-- Update finished - 100% Good Style --'
  end

  def get_all_thread_posts_rse_id
    @new_thread_posts_rse_id = []
    opts                     = {threaded: true}
    up_to_date               = false

    begin
      thread_posts = manage_api_limits :message do
        @yam.messages_in_group(@group.rse_id, opts).body[:messages]
      end

      thread_posts.each do |thread_post|
        if ThreadPost.where(rse_id: thread_post[:id]).empty?
          @new_thread_posts_rse_id.unshift thread_post[:id]
        else
          up_to_date = true
          break
        end
      end
      opts[:older_than] = thread_posts.last[:id] unless thread_posts.empty?
    end until thread_posts.empty? || up_to_date

    @new_thread_posts_rse_id
  end

  def update_thread_posts
    thread_posts_rse_id_in_db = ThreadPost.select('rse_id').where('group_id = ?', @group.id).order('id').map { |thread_post| thread_post.rse_id }
    @thread_posts_rse_id = thread_posts_rse_id_in_db + @new_thread_posts_rse_id

    @thread_posts_rse_id.each_with_index do |thread_post_rse_id, index|
      if ThreadPost.where(rse_id: thread_post_rse_id).empty?
        @thread_post_fetched = manage_api_limits :thread do
          @yam.get_thread(thread_post_rse_id).body
        end

        @thread_post = ThreadPost.new(rse_id: @thread_post_fetched[:id])

        qualify_thread
        @thread_post.group = @group
        @thread_post.save

      else
        @thread_post = ThreadPost.find_by_rse_id(thread_post_rse_id)
      end

      plural = @thread_posts_rse_id.count > 1 ? 's' : ''
      puts "#{index + 1}/#{@thread_posts_rse_id.count} thread#{plural} fetched"

      @thread_post_rse_id = thread_post_rse_id
      get_new_messages_ids_from_thread
    end
  end

  def qualify_thread
    first_reply = manage_api_limits :message do
      Yammer::GetMessage.new(@user, @thread_post.rse_id).call
    end

    innovation_disruption = InnovationDisruptionThread.new(first_reply[:plain]).call
    business_technology   = BusinessTechnologyThread.new(first_reply[:plain]).call

    @thread_post.innovation_disruption = innovation_disruption[1] unless innovation_disruption.nil?
    @thread_post.business_technology   = business_technology[1] unless business_technology.nil?
  end

  def get_new_messages_ids_from_thread
    opts                    = {}
    up_to_date              = false
    thread_messages_rse_ids = []

    begin
      messages_in_thread = manage_api_limits :message do
        @yam.messages_in_thread(@thread_post_rse_id, opts).body[:messages]
      end

      messages_in_thread.each do |message_in_thread|
        if Message.where(rse_id: message_in_thread[:id]).empty?
          thread_messages_rse_ids.unshift message_in_thread[:id]
        else
          up_to_date = true
          break
        end
      end
      opts[:older_than] = messages_in_thread.last[:id] unless messages_in_thread.empty?
    end until messages_in_thread.empty? || up_to_date

    @new_messages_rse_ids.push thread_messages_rse_ids
  end

  def save_messages_in_db
    if @new_messages_rse_ids.empty?
      puts 'DB up to date'
      return
    else
      plural = @new_messages_rse_ids.count > 1 ? 's' : ''
      puts "-- #{@new_messages_rse_ids.count} Message#{plural} to fetch --"
    end

    @new_messages_rse_ids.each_with_index do |message_id, index|
      @message            = get_message(message_id)
      @message[:liked_by] = get_likes(message_id)

      new_message = Message.new(@message)

      message_sender = manage_api_limits :user do
        Yammer::GetUser.new(@user, @message_fetched[:sender_id]).call
      end

      new_message.thread_post = ThreadPost.find_by_rse_id(@message_fetched[:thread_id])
      unless @message[:rse_replied_to_id].nil?
        new_message.replied_to_id = Message.find_by_rse_id(@message[:rse_replied_to_id]).id
      end
      new_message.user = message_sender
      new_message.save

      puts "#{index + 1} / #{@new_messages_rse_ids.count}"
      puts new_message.plain
    end
  end

  def get_message(message_id)
    @message_fetched = manage_api_limits :message do
      @yam.get_message(message_id).body
    end

    {
      rse_id:            @message_fetched[:id],
      rse_replied_to_id: @message_fetched[:replied_to_id],
      web_url:           @message_fetched[:web_url],
      plain:             @message_fetched[:body][:plain],
      parsed:            @message_fetched[:body][:parsed],
      notified_by:       @message_fetched[:notified_user_ids].count
    }
  end

  def get_likes(message_id)
    manage_api_limits :user do
      @yam.get("/api/v1/users/liked_message/#{message_id}.json").body[:users].count
    end
  end

  def manage_api_limits(type_of_limit)
    tempo_max = 35
    rate_limits = 10

    if @count_api_limits[type_of_limit][:count] == rate_limits

      tempo = [0, tempo_max - (Time.now - @count_api_limits[type_of_limit][:timer]).round].max

      puts "-- Waiting #{tempo} sec because of API #{type_of_limit.to_s}'s rate limits --"
      sleep(tempo)

      @count_api_limits[type_of_limit][:timer] = Time.now
      @count_api_limits[type_of_limit][:count] = 1
    else
      @count_api_limits[type_of_limit][:count] += 1
    end

    yield
  end
end
