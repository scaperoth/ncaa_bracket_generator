class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
end