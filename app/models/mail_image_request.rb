class MailImageRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w|forward scan disposal|

  field :type, type: String
  validates :type, presence: true, inclusion: {in: TYPES}

  field :complete, type: Mongoid::Boolean, default: false
  field :completed_at, type: Time

  field :tracking_id, type: String
  # validate :tracking_number_if_complete

  belongs_to :client

  belongs_to :mail_image

  scope :complete, -> { where(complete: true) }

  before_save :set_completed_at

  private

  def set_completed_at
    if self.complete?
      self.completed_at = Time.now
    else
      self.completed_at = nil
    end
  end

  def tracking_number_if_complete
    errors.add(:tracking_number, 'cannot be blank') if complete? && tracking_number.blank?
  end
end
