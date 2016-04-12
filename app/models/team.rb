class Team < ActiveRecord::Base
  belongs_to :kenpom_team
  belongs_to :bmatrix_team
  belongs_to :conference
  
  has_many :brackets
  has_many :tournaments, :through => :brackets
  has_many :regions, :through => :brackets
  has_many :rounds, :through => :brackets
end