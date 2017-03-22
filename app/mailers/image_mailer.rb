require 'open-uri'

class ImageMailer < ApplicationMailer
  default from: "Sage Workspace <#{ENV['MAILER_EMAIL']}>",
          return_path: ENV['MAILER_EMAIL'],
          sender: ENV['MAILER_EMAIL']

  def notify_client_of_keyword_matches(client, email_content_array)
    delivery_options = {:password => ENV['MAILER_PASSWORD']}
    @client = client

    # unless Rails.env.development?
      email_content_array.each do |c|
        # email_content_array is an array of hashes containting :keyword, :image
        # attachments[c[:keyword]] = MiniMagick::Image.open(c[:image])
        attachments[c[:keyword]] = open(c[:image]).read
      end
    # end

    mail(to: "#{@client.name} <#{@client.email}>", subject: "Mail Notification", :delivery_method_options => delivery_options)
  end
end
