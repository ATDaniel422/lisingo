require 'bodysnatcher'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def index
  end

  def search_bar
	@search_text = BodySnatcher::WebParser.new(params[:q])
	if @search_text.blank?
	  redirect_to(root_path, alert("search bar is empty")) and return
	else
	@text = @search_text.content_text
	@job = Job.create(text_to_process:@text)
	while ! @job.reload.completed?
		sleep(1)
	end 
	render("Results.html.erb")
	end
  end
  def results
	
  end
end
