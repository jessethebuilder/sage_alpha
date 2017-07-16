class Client
  include Mongoid::Document
  include Mongoid::Timestamps
  include FarmShed

  field :name, type: String
  validates :name, presence: true

  field :email, type: String
  validates :email, presence: true, uniqueness: true

  field :keywords, type: Array, default: []
  validates :keywords, presence: true

  field :company_name, type: String

  field :phone, type: String

  field :client_number, type: String

  has_many :client_keyword_matches, dependent: :destroy

  has_many :mail_image_requests, dependent: :destroy

  # :user is only optional, so Client can be created. The after_create action below
  # always creates a User for this client when Client is created
  belongs_to :user, optional: true, dependent: :destroy

  # has_and_belongs_to_many :mail_images

  has_many :mail_queues

  def send_email(images)
    ImageMailer.notify_client_of_keyword_matches(self, images).deliver_now
    puts "Email sent to #{self.name} at #{Time.now.strftime('%D %r')}."
    true
  end

  def keywords=(words)
    # :keywords are made into an array, as they come in as a string via Controller
    if words.class == String
      w = words.split(/, ?/)
      super(w)
    else
      super(words)
    end
  end

  def display_keywords
    self.keywords.join(', ')
  end

  def mail_images
    client_keyword_matches.map{ |ckm| ckm.mail_image }.uniq
  end

  after_create :create_user
  after_save :update_user

  private

  def create_user
    pw = random_password
    u = User.new(email: self.email, password: pw)
    self.user = u
    self.save
    u.save
  end

  def update_user
    if email_changed?
      u = self.user
      u.email = self.email
      u.save
    end
  end
end
