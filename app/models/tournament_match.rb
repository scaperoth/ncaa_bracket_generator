class TournamentMatch < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :region
  belongs_to :round
  belongs_to :team1, class_name: 'TeamsTournament', foreign_key: "team_id"
  belongs_to :team2, class_name: 'TeamsTournament', foreign_key: "team_id"
  belongs_to :winner, class_name: 'TeamsTournament', foreign_key: "team_id"
end
