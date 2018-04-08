class Job < ActiveRecord::Base
	include AASM

	aasm column: :state do
		state :in_queue, initial: true
		state :processing
		state :completed
	end

	validates :text_to_process, presence: true

	after_save do |job|
		if(in_queue?)
			add_to_queue
		end
	end

	def add_to_queue
		p "Adding job #{self.id} to queue"
		PollySubmitWorker.perform_async(id)
	end
end
