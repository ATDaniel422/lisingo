class Job < ActiveRecord::Base
	include AASM

	aasm do
		state :in_queue, initial: true, after_enter: :add_to_queue
		state :processing
		state :completed
	end

	def add_to_queue
		PollySubmitWorker.perform_async(id)
	end
end
