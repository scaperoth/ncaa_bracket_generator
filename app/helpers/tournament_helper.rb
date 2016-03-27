##
# @author Matt Scaperoth
# @email scaperoth@gmail.com
# @description class for new tournament. This class computes the outcomes of matches and stores the results of the tournament in a hash

module TournamentHelper
  
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
    if team1_kp_rank < team2_kp_rank
      team1_wins += 1
    else
      team2_wins += 1 
    end
    
    #outcome of one team in kp and other in bmat
    if team1_kp_rank < team2_bmat_rank
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
end