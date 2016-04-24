class BracketController < ApplicationController
  
  
  def index
    @params = params
    
    @method = "all"
    
    if !params[:method].nil?
      @method = params[:method]
    end
  end
  
  def comparison
    
    @params = params
    
    @method = "all"
    
    if !params[:method].nil?
      @method = params[:method]
    end
  end
  
end
