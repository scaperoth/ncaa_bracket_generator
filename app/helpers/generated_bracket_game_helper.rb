module GeneratedBracketGameHelper
  
  def generate_guess_bracket(method = nil)
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
          winner = match(team1,team2, method)
          
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
      
      game_results
  end
  
  
  def match(team1, team2, method = nil)
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
    
    if method == "kp" or method == "all"
       #check outcome of both teams in kp
      if team1_kp_rank < team2_kp_rank
      team1_wins += 1
      else
      team2_wins += 1
      end
    end
    
    
    if method == "all"
      #outcome of one team in kp and other in bmat
      if team1_kp_rank<team2_bmat_rank
      team1_wins += 1
      else
      team2_wins += 1
      end
    end
    
    
    if method == "all"
      #outcome of one team in bmat the other in kp
      if team1_bmat_rank < team2_kp_rank
      team1_wins += 1
      else
      team2_wins += 1
      end
    end

    
    if method == "bmat" or method == "all"
      #outcome of both teams in bmat
      if team1_bmat_rank < team2_bmat_rank
      team1_wins += 1
      else
      team2_wins += 1
      end
    end

    #return the active record of the winner
    if team1_wins > team2_wins
    return team1
    else
    return team2
    end

  end
end
