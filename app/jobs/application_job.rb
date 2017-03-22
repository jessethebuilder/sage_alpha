class ApplicationJob < ActiveJob::Base
  ActiveJob::Base.queue_adapter = :resque
  
end
