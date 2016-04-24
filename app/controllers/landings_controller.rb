class LandingsController < ApplicationController
  
  
  def index
    @params = params
    
    
    @method = nil
    
    if !params[:method].nil?
      @method = params[:method]
    end
  end
  
  def comparison
    
    @params = params
    
    @method = nil
    
    if !params[:method].nil?
      @method = params[:method]
    end
  end
  
end
