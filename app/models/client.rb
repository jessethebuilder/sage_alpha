class Client
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :keywords, type: Array, default: []

  validates :name, presence: true
  validates :email, presence: true
  validates :keywords, presence: true

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
end
