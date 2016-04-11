class KenpomStat < ActiveRecord::Base
  
  belongs_to :kenpom_team
  belongs_to :tournament
end
