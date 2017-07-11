class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  validates :first_name, presence: true

  field :last_name, type: String

  field :email, type: String
  validates :email, presence: true, uniqueness: true

  field :keywords, type: Array, default: []
  validates :keywords, presence: true

  field :company_name, type: String

  field :phone, type: String

  field :client_number, type: String

  has_many :client_keyword_matches

  def name
    n = self.first_name
    n += " #{self.last_name}" unless self.last_name.blank?
    n
  end
  # has_many :mail_images

  # :user is only optional, so Client can be created. The after_create action below
  # always creates a User for this client when Client is created
  belongs_to :user, dependent: :destroy, optional: true

  has_and_belongs_to_many :mail_images
  has_many :mail_queues

  def send_email(content_array)
    # content_array is an Array of Hashes with 2 keys: :image, :keyword
    ImageMailer.notify_client_of_keyword_matches(self, content_array).deliver_now
    # ImageMailer.notify_client_of_keyword_matches(self, content_array).deliver
    puts "Email sent to #{self.name} at #{Time.now.strftime('%D %r')}."
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

  after_create :create_user

  private

  def create_user
    pw = random_password
    u = User.new(email: self.email, password: pw)
    self.user = u
    self.save
    u.save
  end
end
