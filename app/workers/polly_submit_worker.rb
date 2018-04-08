require 'MP3Generator'

class PollySubmitWorker
  include Sidekiq::Worker

  def perform(job_id)
  	job =Job.find(job_id)
  	p "Processing job ${job_id}"
  	job.update(state: :processing)

  	filename = MP3Generator.generateAudio(job.text_to_process)
  	file = File.open(filename, "rb")
  	s3 = Aws::S3::Resource.new(region:'us-east-1')
    key = SecureRandom.uuid
    object = s3.bucket('lisingo').object(key)
    result = object.put(body: file)
    file.close()
    File.delete(filename)
    job.update(bucket_url: object.public_url, state: :completed)
  end
end
