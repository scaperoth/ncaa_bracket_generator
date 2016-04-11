class BmatrixTeam < ActiveRecord::Base
  has_one :team
  has_many :bmatrix_stats
  
  has_many :tournaments, :through => :bmatrix_stats
end
