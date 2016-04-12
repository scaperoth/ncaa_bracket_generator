class Region < ActiveRecord::Base
   has_many :tournament_matches
   
   has_many :tournaments, :through => :tournament_matches
   has_many :rounds, :through => :tournament_matches
   has_many :teams, :through => :tournament_matches
end
