class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
  
  has_many :tournament_teams
  has_many :tournaments, :through => :tournament_teams
end