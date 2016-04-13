class Round < ActiveRecord::Base
  has_many :bracket_games
  has_many :tournaments, :through => :bracket_games
  has_many :regions, :through => :bracket_games
  has_many :teams, :through => :bracket_games
end

