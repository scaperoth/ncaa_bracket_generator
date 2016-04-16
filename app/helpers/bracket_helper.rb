#
# Helps build the bracket
#

module BracketHelper
  
  # creates a bracket from given teams
  def create_bracket_round(games, guess_bracket = false)
    current_round = 0
    current_region = 0
    matches = ""
    bracket = ""
    
    #control the directions of the connectors
    connector1_direction = "top"  
    connector2_direction = "bottom" 
    
    #loop through the games
    games.each do |game|
      
      #swap connector directions on each pass
      connector1_direction == "top" ? connector1_direction = "bottom" : connector1_direction = "top" 
      connector2_direction == "bottom" ? connector2_direction = "top" : connector2_direction = "bottom"
      
      round = Round.find_by id: game.round_id
      
      #the round number expressed as a float
      round_number = round.number.to_f
      
      #the height of each match
      height = 2 ** (round_number-1) * 64
      
      #get the team data
      team1 = Team.find_by id: game.team_id
      team2 = Team.find_by id: game.team2_id
      
      if guess_bracket
        team_blocks = create_team_block(team1, team2, match(team1, team2))
      else
        team_blocks = create_team_block(team1, team2, game.winner)
      end
      
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
  
  def create_team_block(team1, team2, winner)
    
      #for both teams, create their block
      team1_block = content_tag :div, class: "team " + (winner.id == team1.id ? "win": "lose"), "data-resultid"=> "team-#{team1.id}", "data-teamid" => "#{team1.id}" do
        content_tag(:label, team1.name, class: "label")+
        content_tag(:div, (winner.id == team1.id ? "1": "0"), class: "score", "data-resultid" => "result-#{team1.id}")
      end
      
      team2_block = content_tag :div, class: "team " + (winner.id == team2.id ? "win": "lose"), "data-resultid"=> "team-#{team2.id}", "data-teamid" => "#{team2.id}"  do
        content_tag(:label, team2.name, class: "label")+
        content_tag(:div, (winner.id == team2.id ? "1": "0"), class: "score", "data-resultid" => "result-#{team2.id}")
      end
      
      team_block = team1_block + team2_block
      
  end
  
  def generate_guess_bracket
      team_block = ""
      
      games = BracketGame.where(round_id: 1).order(:region_id, :round_id, :weight)
      
      return team_block
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