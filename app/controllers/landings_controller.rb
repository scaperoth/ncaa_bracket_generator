class LandingsController < ApplicationController
  def index
    
    @crawler = Crawler.new
  end
end
