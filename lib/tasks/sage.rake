require 'assets/image_reader'

namespace :sage do
  # task :read => :environment do
  #   i = ImageReader.new(ENV['OCRESTFUL_BASE_URL'],
  #                       ENV['OCRESTFUL_API_SECRET'],
  #                       Rails.root.join('temp/2.png '))
  #   i.scan
  #   puts i.read_as_text
  # end

  # task :read => :environment do
  #   ocr = MailReader.new
  #   ocr.read(Rail.root.join('temp/2.png')).strip
  # end
  #
  # task :r => :read



  task :send_emails => :environment do
    count = 0

    MailQueue.unsent.each do |mq|
      count += mq.send_emails
    end

    F.append("#{Rails.root}/log/rake_log.log", "sage:send_emails at #{Time.now.strftime('%D %r')}. #{count} email/s sent.\n")
  end
end
