class MailQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :mail_images, dependent: :destroy

  field :sent_emails_count, type: Integer, default: 0

  field :emails_complete, type: Boolean, default: false

  scope :unsent, -> { where(emails_complete: false) }

  def name
    self.created_at.strftime('%D %r')
  end

  def mail_images_for(client)
    client.mail_images.map{ |mi| mi if mi.mail_queue == self }.delete_if{ |mi| mi.nil? }
  end

 

  def send_emails
    count = 0
    # Uses :client_keyword_matches on each MailImage to sort which attachemnts get sent to which client

    Client.all.each do |c|
      # For every Client, loop every client_keyword_match on every MailImage

      # Values in :client_keyword_matches (on MailImage) is a hash with 2 keys:
      # :client_id, :keyword
      mail_content_array = []
      matches = []
      # image_attachment_array = []

      self.mail_images.each do |img|
        img.client_keyword_matches.each do |match|
          if c.id == match.client.id && !matches.map{ |m| puts m.inspect }.include?(c.id)
            # If this client matches the client_id, and if an email HAS NOT been sent
            # to this client based on this MailQueue
            # if !image_attachment_array.include?(image_path)
            if !c.mail_images.include?(img)
              image_path = img.image
              # if this image has not already been attached to this email
              h = {}
              h[:image] = image_path
              ext = image_path.split('.').last
              h[:keyword] = match.keyword + '.' + ext
              mail_content_array << h

              c.mail_images << img
              matches << match
            end

          end
        end
      end

      # Client sends the email models/client
      unless mail_content_array.blank?
        c.send_email(mail_content_array)
        count += 1
        # self.update(sent_emails_count: self.sent_emails_count + 1)
        self.sent_emails_count = self.sent_emails_count + 1
        # Record if this client has been emailed
        # self.client_ids_that_have_been_emailed << c.id
        self.save
      end
    end # each Client

    matches.each{ |m| m.update(email_sent: true) }
    self.update(emails_complete: true)

    return count
  end



end
