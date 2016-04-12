class Tournament < ActiveRecord::Base
  
  has_many :teams_tournaments
  
  has_many :teams, :through => :teams_tournaments
  
end
