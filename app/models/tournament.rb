class Tournament < ActiveRecord::Base
  
  has_many :tournament_teams
  has_many :bmatrix_stats
  has_many :kenpom_stats
  has_many :tournament_matches
  
  has_many :teams, :through => :tournament_teams
  has_many :bmatrix_teams, :through => :bmatrix_stats
  has_many :kenpom_teams, :through => :kenpom_stats
  
   
  has_many :rounds, :through => :tournament_matches
  has_many :regions, :through => :tournament_matches
  has_many :teams, :through => :tournament_matches
  
end
