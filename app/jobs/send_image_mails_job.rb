class SendImageMailsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    args[0].unsent.each do |mq|
      mq.send_emails
    end
  end
end
