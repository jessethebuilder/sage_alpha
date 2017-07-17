require 'assets/image_reader'

namespace :sage do
  task :send_emails => :environment do
    count = 0

    MailQueue.marked_for_completion.each do |mq|
      count += mq.send_emails
    end

    F.append("#{Rails.root}/log/rake_log.log", "sage:send_emails at #{Time.now.strftime('%D %r')}. #{count} email/s sent.\n")
  end
end
