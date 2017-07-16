class ClientKeywordMatch
  include Mongoid::Document

  belongs_to :mail_image

  belongs_to :client

  field :keyword, type: String
  validates :keyword, presence: true

  field :email_sent, type: Boolean, default: false
end
