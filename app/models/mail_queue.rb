class MailQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :mail_images, dependent: :destroy

  field :sent_emails_count, type: Integer, default: 0
  field :emails_complete, type: Boolean, default: false

  def send_emails
    # Uses :client_keyword_matches on each MailImage to sort which attachemnts get sent to which client

    Client.all.each do |c|
      # For every Client, loop every client_keyword_match on every MailImage

      # Values in :client_keyword_matches (on MailImage) is a hash with 2 keys:
      # :client_id, :keyword
      mail_content_array = []

      self.mail_images.each do |img|
        img.client_keyword_matches.each do |match|

          if c.id == match[:client_id]
            # If this client matches the client_id
            h = {}
            h[:image] = img.image
            h[:keyword] = match[:keyword]
            mail_content_array << h
          end
        end
      end

      # Client sends the email models/client
      c.send_email(mail_content_array)

      self.update(sent_emails_count: self.sent_emails_count + 1)
    end

    self.update(emails_complete: true)
  end

  def name
    self.created_at.strftime('%D %r')
  end

end
