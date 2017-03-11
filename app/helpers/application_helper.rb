module ApplicationHelper
  def available_brackets
    Tournament.where("id IN (?) ", BracketGame.select(:tournament_id))
  end
  
  def home_page? 
    current_page?(root_url)
  end
end
