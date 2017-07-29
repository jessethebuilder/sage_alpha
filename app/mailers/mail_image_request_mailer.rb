require 'open-uri'

class MailImageRequestMailer < ApplicationMailer
  default from: "Sage Workspace <#{ENV['MAILER_EMAIL']}>",
          return_path: ENV['MAILER_EMAIL'],
          sender: ENV['MAILER_EMAIL']

  def notify_client_of_request_completion(mail_image_request)
    @mail_image_request = mail_image_request
    @mail_image = @mail_image_request.mail_image
    @client = @mail_image_request.client
    delivery_options = {:password => ENV['MAILER_PASSWORD']}

    mail(to: "#{@client.name} <#{@client.email}>", subject: "#{@mail_image_request.type.titlecase} Request Completed (Do not Reply)", :delivery_method_options => delivery_options)
  end


end
