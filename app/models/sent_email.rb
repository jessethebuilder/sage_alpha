class SentEmail
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :mail_queue

  belongs_to :client
end
