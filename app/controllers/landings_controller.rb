class LandingsController < ApplicationController
  def index
    
    @crawler = Crawler.new("http://localhost:3000/test") 
  end
end
