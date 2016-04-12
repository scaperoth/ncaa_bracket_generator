class TournamentMatch < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :region
  belongs_to :round
  belongs_to :team1, class_name: 'Team'
  belongs_to :team2, class_name: 'Team'
  belongs_to :winner, class_name: 'Team'
end
