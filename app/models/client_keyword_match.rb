class ClientKeywordMatch
  include Mongoid::Document

  belongs_to :mail_image

  belongs_to :client

  field :keyword, type: String
  validates :keyword, presence: true

  field :email_sent, type: Boolean, default: false

  before_create :delete_conflicting_matches

  private

  def delete_conflicting_matches
    # Only 1 ClientKeywordMatch can exist per MailImage. This deletes any, in the
    # event that User matches a MailImage that already matches to a new Client

    ClientKeywordMatch.where(mail_image_id: self.mail_image.id).destroy_all
  end
end
