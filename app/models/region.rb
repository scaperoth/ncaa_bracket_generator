class Region < ActiveRecord::Base
  has_many  :tournament_match
end
