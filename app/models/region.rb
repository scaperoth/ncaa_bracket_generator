class Region < ActiveRecord::Base
  
  has_many :brackets
  has_many :tournaments, :through => :brackets
  has_many :rounds, :through => :brackets
  has_many :teams, :through => :brackets
end
