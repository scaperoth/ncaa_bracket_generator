#
# Helps build the bracket
#

module BracketHelper
  
  
  # creates a bracket from given teams
  def create_bracket(generated = false, with_comparison = false, method = nil)
    num_wrong_guesses = 0
    num_games = BracketGame.all.count
    bracket = ""
    curr_region = nil
    
    if generated
      generated_bracket = JSON.parse(generate_guess_bracket(method).to_json)
    end
    
    #concat content_tag :h1, num_wrong_guesses
    
    Round.where.not(number: 0).order(:number).each do |round| 
      
      matches = ""
      games_obj = BracketGame.where(round_id: round.id).order(:region_id, :weight)
      
      
      games_json = games_obj.to_json
      
      #control the directions of the connectors
      connector1_direction = "top"  
      connector2_direction = "bottom" 
      
      games = JSON.parse(games_json)
      
      #loop through the games
      games.each do |game, index|
        region = Region.find_by id: game["region_id"]
        
        
        #swap connector directions on each pass
        connector1_direction == "top" ? connector1_direction = "bottom" : connector1_direction = "top" 
        connector2_direction == "bottom" ? connector2_direction = "top" : connector2_direction = "bottom"
        
        round = Round.find_by id: game["round_id"]
        
        #the round number expressed as a float
        round_number = round.number.to_f
        
        #the height of each match
        height = 2 ** (round_number-1) * 82
        
        # get the team data from tournament
        team1 = Team.find_by id: game["team_id"]
        team2 = Team.find_by id: game["team2_id"]
        winner = Team.find_by id: game["winner_id"]
        
        if generated 
          
    
          #get the corresponding bracket game generated from stats
          generated_game = nil
          
          generated_bracket.collect{|generated_bracket_game|
                
                if generated_bracket_game["region_id"] == game["region_id"] and
                  generated_bracket_game["round_id"] == game["round_id"] and
                  generated_bracket_game["weight"] == game["weight"]
                  
                  generated_game = generated_bracket_game
                  #concat  (game["region_id"].to_s + " : " + game["round_id"].to_s+ " : " + game["weight"].to_s+"<br/>").html_safe
                  
                end
            }
                #concat ("game: "+game.to_s+"</br>").html_safe
                #concat ("generated_game: "+generated_game.to_s+"</br>").html_safe
          
          
          # get the team data from statistics
          generated_team1 = Team.find_by id: generated_game["team_id"]
          generated_team2 = Team.find_by id: generated_game["team2_id"]
          generated_winner = Team.find_by id: generated_game["winner_id"]
          
          team1_accurate= (team1 == generated_team1) ? true : false
          team2_accurate = (team2 == generated_team2) ? true : false
          winner_accurate = (winner == generated_winner) ? true : false
          
          if with_comparison
            
            if !winner_accurate
              num_wrong_guesses += 1
            end
            team_blocks = create_team_block(generated_team1, generated_team2, generated_winner,winner)
          else
            team_blocks = create_team_block(generated_team1, generated_team2, generated_winner)
          end
        else
          team_blocks = create_team_block(team1, team2, winner)
        end # end if generated
        
        #create the connectors as long as it's not the final round
        if !round.name.eql? "Championship"
          connector = content_tag :div, class: "connector", style: "height: #{height/2}px; width: 20px; right: -22px; #{connector2_direction}: #{13 + 27/2}px; border-#{connector1_direction}-style: none;" do
            content_tag("div", "", class: "connector", style: "width: 20px; right: -20px; #{connector1_direction}: 0px;")
          end
        else
          #if it is the final round, just return a blank string
          connector = ""
        end #end championship round
        
        #add the previous htm to the team container
        teamContainer = content_tag :div, team_blocks+connector, class: "teamContainer", style: "top: #{(height-53)/2}px"
        #add the team container to the list of all matches 
        matches += content_tag :div, teamContainer, class: "match", style: "height:"+height.to_s + "px" 
      end # end games foreach
      
      bracket += content_tag :div, matches.html_safe, class: "round"
    end  
    
    if generated and with_comparison
      #concat content_tag :h3, num_games
      #concat content_tag :h3, num_wrong_guesses
    end
    
    if generated
      accuracy = content_tag :h1, number_to_percentage((1-(num_wrong_guesses.to_f/num_games.to_f))*100).to_s+" accurate" 
      return {accuracy: accuracy, bracket: bracket.html_safe}
    end
    
    return {bracket: bracket.html_safe}
  end
  
  def create_team_block(team1, team2, winner, generated_winner = nil)
      
      #concat ("<h2>"+@percent_correct.to_s+"</h2>").html_safe
      team1_winner = winner.id == team1.id
      team2_winner = winner.id == team2.id
      team1_winner_class = team1_winner  ? "win ": "lose"
      team2_winner_class = team2_winner  ? "win ": "lose"
      team1_winner_score = team1_winner  ? "W ": "L"
      team2_winner_score = team2_winner ? "W ": "L"
      
      team1_winner_accurate = true
      team2_winner_accurate = true
      
      if !generated_winner.nil?
        team1_winner_accurate = generated_winner == winner ? true : (team1 == generated_winner ? true : false )
        team2_winner_accurate = generated_winner == winner ? true : (team2 == generated_winner ? true : false)  
      else
        
      end
      
      #for both teams, create their block
      team1_block = content_tag :div, class: "team #{team1_winner_accurate} " + team1_winner_class, "data-resultid"=> "team-#{team1.id}", "data-teamid" => "#{team1.id}" do
        content_tag(:label, team1.name, class: "label")+
        content_tag(:div, team1_winner_score, class: "score", "data-resultid" => "result-#{team1.id}")
      end
      
      team2_block = content_tag :div, class: "team #{team2_winner_accurate} " + team2_winner_class, "data-resultid"=> "team-#{team2.id}", "data-teamid" => "#{team2.id}"  do
        content_tag(:label, team2.name, class: "label")+
        content_tag(:div, team2_winner_score, class: "score", "data-resultid" => "result-#{team2.id}")
      end
      
      team_block = team1_block + team2_block
      
  end
  
  
end