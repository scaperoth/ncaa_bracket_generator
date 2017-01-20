module ApplicationHelper
  def available_brackets
    Tournament.where("id IN (?) ", BracketGame.select(:tournament_id))
  end
end
