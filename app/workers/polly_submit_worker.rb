class PollySubmitWorker
  include Sidekiq::Worker

  def perform(job_id)
  	job =Job.find(job_id)
  	
  end
end
