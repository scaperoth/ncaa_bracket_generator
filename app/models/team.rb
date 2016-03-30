class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  
  
end