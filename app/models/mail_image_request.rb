class MailImageRequest
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %w|forward scan disposal|
  SHIPPING_COMPANIES = %w|USPS UPS FedEx Other|

  field :type, type: String
  validates :type, presence: true, inclusion: {in: TYPES}

  field :complete, type: Mongoid::Boolean, default: false
  field :completed_at, type: Time

  field :tracking_id, type: String
  validate :tracking_id_if_forward_and_complete

  field :shipping_company, type: String
  validate :shipping_company_if_forward

  belongs_to :client

  belongs_to :mail_image

  scope :complete, -> { where(complete: true) }

  before_save :set_completed_at

  private

  def set_completed_at
    if complete_changed?
      if self.complete?
        # self.update_attribte(:completed_at, Time.now);
        self.completed_at = Time.now
        MailImageRequestMailer.notify_client_of_request_completion(self).deliver_now
      else
        self.completed_at = nil
      end
    end
  end

  # These last two validations have not been properly spec'ed yet. jfx

  def tracking_id_if_forward_and_complete
    errors.add(:tracking_id, 'cannot be blank if type is "Forward"') if complete? && type == 'forward' && tracking_id.blank?
  end

  def shipping_company_if_forward
    errors.add(:shipping_company, 'cannot be blank if type is "Forward"') if type == 'forward' && shipping_company.blank?
  end
end
