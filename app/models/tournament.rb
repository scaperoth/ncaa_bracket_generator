class Tournament < ActiveRecord::Base
  has_many :brackets
  has_many :regions, :through => :brackets
  has_many :rounds, :through => :brackets
  has_many :teams, :through => :brackets
end
