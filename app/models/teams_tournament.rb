class TeamsTournament < ActiveRecord::Base
  belongs_to :team
  belongs_to :tournament
  
  has_many  :tournament_matches
  
end
