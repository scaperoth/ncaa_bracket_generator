#
# Helps build the bracket
#

module BracketHelper
  :generated_games
  
  # creates a bracket from given teams
  def create_bracket_round(games, guess_bracket = false)
    generated_bracket = JSON.parse(generate_guess_bracket.to_json)
    current_round = 0
    current_region = 0
    matches = ""
    bracket = ""
    
    #control the directions of the connectors
    connector1_direction = "top"  
    connector2_direction = "bottom" 
    
    games = JSON.parse(games)
    
    #loop through the games
    games.each do |game, index|
      #swap connector directions on each pass
      connector1_direction == "top" ? connector1_direction = "bottom" : connector1_direction = "top" 
      connector2_direction == "bottom" ? connector2_direction = "top" : connector2_direction = "bottom"
      
      round = Round.find_by id: game["round_id"]
      
      #the round number expressed as a float
      round_number = round.number.to_f
      
      #the height of each match
      height = 2 ** (round_number-1) * 64
      
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
        
      # get the team data from tournament
      team1 = Team.find_by id: game["team_id"]
      team2 = Team.find_by id: game["team2_id"]
      winner = Team.find_by id: game["winner_id"]
      
      # get the team data from statistics
      generated_team1 = Team.find_by id: generated_game["team_id"]
      generated_team2 = Team.find_by id: generated_game["team2_id"]
      generated_winner = Team.find_by id: generated_game["winner_id"]
      
      team1_accurate= team1 == generated_team1 ? true : false
      team2_accurate = team2 == generated_team2 ? true : false
      winner_accurate = winner == generated_winner ? true : false
      
      team_blocks = create_team_block(team1, team2, winner, team1_accurate, team2_accurate, winner_accurate)
      
      #create the connectors as long as it's not the final round
      if !round.name.eql? "Championship"
        connector = content_tag :div, class: "connector", style: "height: #{height/2}px; width: 20px; right: -22px; #{connector2_direction}: #{13 + 27/2}px; border-#{connector1_direction}-style: none;" do
          content_tag("div", "", class: "connector", style: "width: 20px; right: -20px; #{connector1_direction}: 0px;")
        end
      else
        #if it is the final round, just return a blank string
        connector = ""
      end
      
      #add the previous htm to the team container
      teamContainer = content_tag :div, team_blocks+connector, class: "teamContainer", style: "top: #{(height-53)/2}px"
      #add the team container to the list of all matches 
      matches += content_tag :div, teamContainer, class: "match", style: "height:"+height.to_s + "px" 
      
    end
    
    bracket = content_tag :div, matches.html_safe, class: "round"
    
    return bracket.html_safe
  end
  
  def create_team_block(team1, team2, winner, team1_accuracy = nil, team2_accuracy = nil, winner_accuracy = nil)
    
      #for both teams, create their block
      team1_block = content_tag :div, class: "team #{team1_accuracy} " + (winner.id == team1.id ? "win ": "lose"), "data-resultid"=> "team-#{team1.id}", "data-teamid" => "#{team1.id}" do
        content_tag(:label, team1.name, class: "label")+
        content_tag(:div, (winner.id == team1.id ? "1": "0"), class: "score", "data-resultid" => "result-#{team1.id}")
      end
      
      team2_block = content_tag :div, class: "team #{team2_accuracy} " + (winner.id == team2.id ? "win": "lose"), "data-resultid"=> "team-#{team2.id}", "data-teamid" => "#{team2.id}"  do
        content_tag(:label, team2.name, class: "label")+
        content_tag(:div, (winner.id == team2.id ? "1": "0"), class: "score", "data-resultid" => "result-#{team2.id}")
      end
      
      team_block = team1_block + team2_block
      
  end
  
  def generate_guess_bracket
      game_results = []
      next_round_teams = {}
      next_round_games = []
      team_appendix = ""
      
      #[{"id":11,"tournament_id":1,"round_id":7,"region_id":1,"team_id":133,"team1_score":null,"team2_id":19,"team2_score":null,"weight":0,"winner_id":133,"created_at":"2016-04-17T02:47:58.526Z","updated_at":"2016-04-17T02:47:58.526Z"},
      # {"id":10,"tournament_id":1,"round_id":7,"region_id":1,"team_id":56,"team1_score":null,"team2_id":59,"team2_score":null,"weight":1,"winner_id":59,"created_at":"2016-04-17T02:47:58.526Z","updated_at":"2016-04-17T02:47:58.526Z"}]
      
      #get first round results
      Round.where.not(number: 0).order(:number).each do |round|
        #concat (round.name+"</br>").html_safe
        existing_games = JSON.parse(BracketGame.where(round_id: round.id).order(:region_id, :weight).to_json)
        games = existing_games
        
        if round.number > 1
          games = next_round_games
          next_round_games = []
          #concat games
        end
        
        games.each do |game |  
          
          #concat (game["weight"].to_s+": ").html_safe
          #concat (game["region_id"].to_s + "<br/>").html_safe
          team1 = Team.find_by id: game["team_id"]
          team2 = Team.find_by id: game["team2_id"]
          winner = match(team1,team2)
          
          game_results.push({"round_id": round.id, 
            "region_id": game["region_id"],
            "weight": game["weight"],
            "team_id": team1.id,
            "team2_id":team2.id,
            "winner_id": winner.id
            })
          
          next_round_teams["team"+team_appendix+"_id"] = winner.id
          team_appendix = team_appendix.empty? ? "2" : ""
          
          #concat ("LAST: "+games.last.to_s+"</br>").html_safe
          #concat ("GAME: "+game.to_s+"</br>").html_safe
          #concat ("Equal: "+ (games.last == game).to_s+"</br>").html_safe
          
          if next_round_teams.length == 4
            
            if round.number.to_i >= (Round.find_by name: "Elite Eight").number
              next_round_teams["region_id"] = nil
              next_round_teams["weight"] = games.last == game ? 1 : 0
            else
              next_round_teams["region_id"] = game["region_id"]
            end
            
            if round.name == "Final Four" 
              next_round_teams["weight"] = 0
            end
            
            next_round_games.push(next_round_teams)
            next_round_teams = {}
            next
          end
          
          if next_round_teams.length == 1
            next_round_teams["weight"] = game["weight"]/2
            
            if round.number.to_i >= (Round.find_by name: "Sweet 16").number
              next_round_teams["weight"] = game["region_id"].to_i - 1
            end
            
            if round.number.to_i >= (Round.find_by name: "Elite Eight").number
              next_round_teams["region_id"] = nil
            else
              next_round_teams["region_id"] = game["region_id"]
            end
          end
        end
      end
      
      @generated_games = game_results
  end
  
  def match(team1, team2)
    #team1_name = Team.find_by name: team1
    #team2_name = Team.find_by name: team2

    #team1_kp_name = team1
    #team2_kp_name = team2
    #team1_bmat_name = team1
    #team2_bmat_name = team2

    #set active recrod values
    team1_kp = KenpomStat.find(team1.kenpom_team_id)
    team2_kp = KenpomStat.find(team2.kenpom_team_id)
    team1_bmat = BmatrixStat.find(team1.bmatrix_team_id)
    team2_bmat = BmatrixStat.find(team2.bmatrix_team_id)

    #get rank of each team in each source
    team1_kp_rank = team1_kp.rank
    team2_kp_rank = team2_kp.rank
    team1_bmat_rank = team1_bmat.rank
    team2_bmat_rank = team2_bmat.rank

    #initialize wins to zero
    team1_wins = 0
    team2_wins = 0

    #check outcome of both teams in kp
    if team1_kp_rank < team2_kp_rank
    team1_wins += 1
    else
    team2_wins += 1
    end

    #outcome of one team in kp and other in bmat
    if team1_kp_rank<team2_bmat_rank
    team1_wins += 1
    else
    team2_wins += 1
    end

    #outcome of one team in bmat the other in kp
    if team1_bmat_rank < team2_kp_rank
    team1_wins += 1
    else
    team2_wins += 1
    end

    #outcome of both teams in bmat
    if team1_bmat_rank < team2_bmat_rank
    team1_wins += 1
    else
    team2_wins += 1
    end

    #return the active record of the winner
    if team1_wins > team2_wins
    return team1
    else
    return team2
    end

  end

  def stats(teams)

    if teams.empty?
      return nil
    end

    stats = Hash.new

    if teams.length > 1
      teams.each do |team_name|

        team = Team.find_by name: team_name
        if !team.nil?

          #set active recrod values
          team_kp = KenpomTeam.find(team.kenpom_team_id)
          team_bmat = BmatrixTeam.find(team.bmatrix_team_id)

          stats.merge!({team_name => {:kprank => team_kp.rank, :bmatrank => team_bmat.rank}})
        end
      end

    end
    print_stats(stats)
  end

  def print_stats(stats)
    output = String.new
    stats.each do |team_name, team_stats|
      output += "<h3>#{team_name}</h3>"
      output += "<p> Ken Pomeroy Rank: #{team_stats[:kprank]} </p>"
      output += "<p> BracketMatrix Rank: #{team_stats[:bmatrank]} </p>"
    end

    output.html_safe

  end
end