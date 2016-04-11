class Tournament < ActiveRecord::Base
  has_many :teams, through: :tournament_teams
  
  has_many :bmatrix_teams, through: :bmatrix_stats
  has_many :kenpom_teams, through: :kenpom_stats
end
