class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
  
  has_many :tournament_teams
  has_many :tournament_matches
  
  has_many :tournaments, :through => :tournament_teams
  has_many :tournaments, :through => :tournament_matches
  has_many :regions, :through => :tournament_matches
  has_many :rounds, :through => :tournament_matches
end