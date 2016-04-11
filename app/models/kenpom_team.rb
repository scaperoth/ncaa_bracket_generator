class KenpomTeam < ActiveRecord::Base
	has_one :team
	has_many :kenpom_stats
	
  has_many :tournaments, :through => :kenpom_stats
end
