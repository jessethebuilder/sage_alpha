class MailQueue
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :mail_images, dependent: :destroy

  field :complete, type: Mongoid::Boolean, default: false

  field :marked_for_completion, type: Mongoid::Boolean, default: false

  embeds_many :sent_emails

  scope :incomplete, -> { where(complete: false) }

  scope :complete, -> { where(complete: true) }

  scope :marked_for_completion, -> { where(marked_for_completion: true).incomplete }

  def name
    D.new(self.created_at).datetime
  end

  def mail_images_for(client)
    client.mail_images.map{ |mi| mi if mi.mail_queue == self }.delete_if{ |mi| mi.nil? }
  end

  def clients
    self.mail_images.map{ |mi| mi.clients }.flatten.uniq
  end

  def send_emails
    count = 0
    self.clients.each do |client|
      # images = email_images_for_client(client)
      images = mail_images_for(client).map{ |mi| mi.image }.uniq
      # Only 1 copy of each image
      client.send_email(images)
      sent = SentEmail.new
      sent.client = client
      self.sent_emails << sent
      count += 1
    end

    self.update_attribute(:complete, true)
    count
  end

  # def email_images_for_client(client)
  #   client.mail_images.select{ |mi| mi.mail_queue == self }.uniq.map{ |mi| mi.image }
  # end
end
