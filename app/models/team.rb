class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
  
  has_many :teams_tournaments
  
  has_many :tournaments, :through => :teams_tournaments
end