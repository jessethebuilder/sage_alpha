require 'open-uri'

class ImageMailer < ApplicationMailer
  default from: "Sage Workspace <#{ENV['MAILER_EMAIL']}>",
          return_path: ENV['MAILER_EMAIL'],
          sender: ENV['MAILER_EMAIL']

  def notify_client_of_keyword_matches(client, images)
    delivery_options = {:password => ENV['MAILER_PASSWORD']}
    @client = client

    # unless Rails.env.development?
      images.each_with_index do |img, i|
        ext = img.split('.').last
        attachments["mail_image_#{i}.#{ext}"] = open(img).read
      end

    mail(to: "#{@client.name} <#{@client.email}>", subject: "Mail Notification (Do not Reply)", :delivery_method_options => delivery_options)
  end
end
