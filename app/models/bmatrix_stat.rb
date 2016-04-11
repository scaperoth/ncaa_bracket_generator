class BmatrixStat < ActiveRecord::Base
  
  belongs_to :bmatrix_team
  belongs_to :tournament
end
