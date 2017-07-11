class MailImageRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w|forward scan disposal|

  field :type, type: String
  validates :type, presence: true, inclusion: {in: TYPES}

  field :complete, type: Mongoid::Boolean
  field :completed_at, type: Time

  belongs_to :client
  # validates :client, presence: true

  belongs_to :mail_image
  # validates :mail_image, presence: true
end
