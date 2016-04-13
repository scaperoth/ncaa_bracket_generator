class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
  
  has_many :bracket_games
  has_many :tournaments, :through => :bracket_games
  has_many :regions, :through => :bracket_games
  has_many :rounds, :through => :bracket_games
end