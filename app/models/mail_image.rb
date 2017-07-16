class MailImage
  include Mongoid::Document
  include Mongoid::Timestamps

  # mail_queue_id is used to pass embedding mail_queue through controller

  field :text, type: String

  field :image, type: String
  validates :image, presence: true

  field :thumb, type: String

  # has_and_belongs_to_many :clients

  belongs_to :mail_queue

  index({created_at: 1}, {unique: true})

  has_many :client_keyword_matches, dependent: :destroy

  has_many :mail_image_requests

  def clients
    self.client_keyword_matches.map{ |ckm| ckm.client }.uniq
  end

  def is_requestable_for?(client)
    client.mail_image_requests.each do |mir|
      if mir.mail_image == self
        if (mir.type == 'disposal' || mir.type == 'forward') && mir.complete?
          return false
        end
      end
    end

    return true
  end

  def match_to_clients
    # Creates ClientKeywordMatches
    Client.all.each do |c|
      c.keywords.each do |k|
        if /#{k}/i =~ self.text
          ckm = ClientKeywordMatch.new(keyword: k)
          ckm.client = c
          ckm.mail_image = self
          ckm.save!
        end
      end
    end
  end
end
