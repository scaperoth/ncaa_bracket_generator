#
# Helps build the bracket
#

module BracketHelper
  def create_bracket()
    html = ""
  end

  def jquery_bracket_generator
    bracket_data = Hash.new
    bracket_data["teams"] = ""
    bracket_data["results"] = ""

    Round.all.order(:number).each do |round|
      if !round.name.eql? "First Four"
         bracket_data["results"] += "["
        Region.all.each do |region|
          
          games = BracketGame.where(round_id: round.id, region_id: region.id)
          if games.nil?
            games = BracketGame.where(round_id: round.id)
          end
          
          games.order(:weight).each do |game|
            team1_id = game.team_id
            team2_id = game.team2_id
            team1 = Team.find_by id: team1_id
            team2 = Team.find_by id: team2_id
            winner = Team.find_by id: game.winner_id
            team1_result = team1.id == winner.id ? 1 : 0
            team2_result = team1_result == 1 ? 0 : 1

            if round.name.eql? "First Round"
              bracket_data["teams"] += "[\"#{team1.name}\", \"#{team2.name}\"],"
            end

            bracket_data["results"] += "[#{team1_result}, #{team2_result}],"
            #bracket_data["results"] += "[0,0],"
          end

        end

        bracket_data["results"] += "],"

      end
    end
    return bracket_data
  end

  def match(team1, team2)
    team1_name = Team.find_by name: team1
    team2_name = Team.find_by name: team2

    #team1_kp_name = team1
    #team2_kp_name = team2
    #team1_bmat_name = team1
    #team2_bmat_name = team2

    #set active recrod values
    team1_kp = KenpomTeam.find(team1_name.kenpom_team_id)
    team2_kp = KenpomTeam.find(team2_name.kenpom_team_id)
    team1_bmat = BmatrixTeam.find(team1_name.bmatrix_team_id)
    team2_bmat = BmatrixTeam.find(team2_name.bmatrix_team_id)

    #get rank of each team in each source
    team1_kp_rank = team1_kp.rank
    team2_kp_rank = team2_kp.rank
    team1_bmat_rank = team1_bmat.rank
    team2_bmat_rank = team2_bmat.rank

    #initialize wins to zero
    team1_wins = 0
    team2_wins = 0

    #check outcome of both teams in kp
    if team1_kp_rank. team2_kp_rank
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
    return team1_kp
    else
    return team2_kp
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