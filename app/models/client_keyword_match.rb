class ClientKeywordMatch
  include Mongoid::Document
  # include Mongoid::Timestamps

  belongs_to :mail_image
  validates :mail_image, presence: true

  # embedded_in :client
  belongs_to :client
  validates :client, presence: true

  field :keyword, type: String
  validates :keyword, presence: true

  field :email_sent, type: Boolean, default: false

end
