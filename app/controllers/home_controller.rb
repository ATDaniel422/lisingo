require "bodysnatcher"
require "uri"
require "net/https"

class HomeController < ApplicationController

  def show
  end

  #POST of url submitted in search bar
  def search
    @search_text = BodySantcher::WebParser.new(params[:search])
    if @search_text.blank?
      redirect_to(root_path, alert("search bar is empty!")) and return
    else
      @text = @search_text.content_text
      @my_connection = Net::HTTP.new(uri.host, uri.port)
      @spoken_text = @my_connection.post(@text)
  end

end
