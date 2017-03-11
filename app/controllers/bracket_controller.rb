class BracketController < ApplicationController
  before_filter :set_tournament_and_method
  
  def index
    games = BracketGame.where(tournament: @tournament)
    if games.empty?
      render "coming_soon"
    end
  end
  
  def comparison
  end
  
  private
  
  def set_tournament_and_method
    if(params['method'].size == 2)
      params[:method] = "all"
    else
      params[:method] = params['method'].keys.first
    end
    
    tournament_year = params[:year] || Time.now.year.to_s
    @tournament = Tournament.find_by year: tournament_year
    
    @bracket_helper = BracketHelper 
    @method = params[:method] || "all"
    
  end
end
