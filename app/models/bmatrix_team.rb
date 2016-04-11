class BmatrixTeam < ActiveRecord::Base
  has_one :team
  has_many :bmatrix_stats
end
