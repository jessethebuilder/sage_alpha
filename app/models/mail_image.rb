class MailImage
  include Mongoid::Document
  include Mongoid::Timestamps

  # mail_queue_id is used to pass embedding mail_queue through controller

  field :text, type: String
  field :image, type: String
  field :thumb, type: String

  field :client_keyword_matches, type: Array, default: []

  has_and_belongs_to_many :clients

  belongs_to :mail_queue

  index({created_at: 1}, {unique: true})

  def queue_emails
    # Checks each Client for a keyword match with this MailImage. If a match
    # exists, create a hash and add to this MailImages :client_keyword_matches attr.
    # This will be used to determine who to send emails to.
    Client.all.each do |c|
      c.keywords.each do |k|
        if /#{k}/i =~ self.text
          h = {}
          h[:client_id] = c.id
          h[:keyword] = k
          self.client_keyword_matches << h
        end
      end
    end
  end
end
