class KenpomTeam < ActiveRecord::Base
	has_one :team
	has_many :kenpom_stats
end
