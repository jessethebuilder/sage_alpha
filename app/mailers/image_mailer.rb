class ImageMailer < ApplicationMailer
  default from: "Sage Workspace <#{ENV['MAILER_EMAIL']}>"

  def notify_client_of_keyword_matches(client, email_content_array)
    delivery_options = {:password => ENV['MAILER_PASSWORD']}
    @client = client

    unless Rails.env.development?
      email_content_array.each do |c|
        # email_content_array is an array of hashes containting :keyword, :image
        # :image is a DataURI string
        # puts c.inspect
        attachments[c[:keyword]] = URI::Data.new(c[:image]).data
      end
    end

    mail(to: "#{@client.name} <#{@client.email}>", subject: "Mail Notification", :delivery_method_options => delivery_options)
  end
end
