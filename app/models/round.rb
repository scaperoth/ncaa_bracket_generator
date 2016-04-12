class Round < ActiveRecord::Base
  has_many :brackets
  has_many :tournaments, :through => :brackets
  has_many :regions, :through => :brackets
  has_many :teams, :through => :brackets
end

