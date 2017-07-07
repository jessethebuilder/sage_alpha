class MailImage
  include Mongoid::Document
  include Mongoid::Timestamps

  # mail_queue_id is used to pass embedding mail_queue through controller

  field :text, type: String
  field :image, type: String
  field :thumb, type: String

  # field :client_keyword_matches, type: Array, default: []

  has_and_belongs_to_many :clients

  belongs_to :mail_queue

  index({created_at: 1}, {unique: true})

  has_many :client_keyword_matches, dependent: :destroy

  def match_to_clients
    # Checks each Client for a keyword match with this MailImage. If a match
    # exists, create a hash and add to this MailImages :client_keyword_matches attr.
    # This will be used to determine who to send emails to.
    Client.all.each do |c|
      c.keywords.each do |k|
        if /#{k}/i =~ self.text
          ckm = ClientKeywordMatch.new(keyword: k)
          ckm.client = c
          ckm.mail_image = self
          ckm.save!

          c.mail_images << self
        end
      end
    end
  end
end
