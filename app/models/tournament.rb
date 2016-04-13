class Tournament < ActiveRecord::Base
  has_many :bracket_games
  has_many :regions, :through => :bracket_games
  has_many :rounds, :through => :bracket_games
  has_many :teams, :through => :bracket_games
end
