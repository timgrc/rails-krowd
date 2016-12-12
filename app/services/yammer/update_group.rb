require 'yammer'

class Yammer::UpdateGroup
  def initialize(user, group_id)
    @yam      = Yammer::Client.new(access_token: user.access_token)
    @user     = user
    @group_id = group_id
  end

  def call
    puts "-- Update start --"
    threads = @yam.messages_in_group(@group_id, threaded: true).body[:messages]

    i = 0
    threads.each do |thread, index|
      # Create or get a thread
      if ThreadPost.find_by_rse_id(thread[:id])
        new_thread = ThreadPost.find_by_rse_id(thread[:id])
      else
        yam_thread = @yam.get_thread(thread[:id]).body

        thread_db = {
          rse_id:          yam_thread[:id],
          web_url:         yam_thread[:web_url],
          updates:         yam_thread[:stats][:updates],
          first_reply_id:  yam_thread[:stats][:first_reply_id],
          latest_reply_id: yam_thread[:stats][:latest_reply_id]
        }

        thread_sender = Yammer::GetUser.new(@yam, thread[:sender_id]).call

        new_thread = ThreadPost.new(thread_db)
        new_thread.user = thread_sender
        new_thread.group = Group.find_by_rse_id(@group_id)

        first_reply = Yammer::GetMessage.new(@yam, yam_thread[:id]).call
        innovation_disruption = InnovationDisruptionThread.new(first_reply[:plain], []).call
        business_technology   = BusinessTechnologyThread.new(first_reply[:plain], []).call

        new_thread.innovation_disruption = innovation_disruption
        new_thread.business_technology   = business_technology

        new_thread.save
      end

      # Catch message ids
      message_rse_ids = []
      while message_rse_ids.count < new_thread[:updates]
        opts = message_rse_ids.empty? ? {} : { older_than: message_rse_ids.last }

        messages = @yam.messages_in_thread(new_thread[:rse_id], opts).body[:messages]
        message_rse_ids += messages.map { |message| message[:id] }
      end

      # Catch messages
      message_rse_ids.each do |message_id|
        # if Message.find_by_rse_id(message_id)
        #   new_message = Message.find_by_rse_id(message_id)
        # else
          likes = @yam.get("/api/v1/users/liked_message/#{message_id}.json").body[:users].count

          message = @yam.get_message(message_id).body
          message_db = {
            rse_id:            message[:id],
            rse_replied_to_id: message[:replied_to_id],
            web_url:           message[:web_url],
            plain:             message[:body][:plain],
            parsed:            message[:body][:parsed],
            notified_by:       message[:notified_user_ids].count,
            liked_by:          likes
          }

          new_message             = Message.new(message_db)
          message_sender          = Yammer::GetUser.new(@yam, message[:sender_id]).call

          new_message.thread_post = new_thread
          new_message.user        = message_sender
          new_message.save
        # end

        i += 1
        percentage = "#{( ( i.to_f / 253.to_f ) * 100 ).round(1)}%"
        puts "#{percentage} - #{i}/253"
        sleep(5)
      end
    end

    puts '-- Update finished - 100% Good Style'
  end
end
