class BracketController < ApplicationController
    before_filter :set_tournament_and_method

    def index
        games = BracketGame.where(tournament: @tournament)
        render 'coming_soon' if games.empty?
    end

    def comparison
    end

    private

    def set_tournament_and_method
        unless params['method'].nil?
            params[:method] = if params['method'].size == 2
                                  'all'
                              else
                                  params['method'].keys.first
                              end
        end

        tournament_year = params[:year] || Time.now.year.to_s
        @tournament = Tournament.find_by year: tournament_year

        @bracket_helper = BracketHelper
        @method = params[:method] || 'all'
      end
end
