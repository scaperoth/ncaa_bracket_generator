# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: ENV["NCAA_ADMIN_USER"], password: ENV["NCAA_ADMIN_PASSWORD"], password_confirmation: ENV["NCAA_ADMIN_PASSWORD"])

#create a new crawler object
@crawler = Crawler.new
#save the seeds from kenpom
seeds = Hash.new

#seed the conferences
conference = ActiveSupport::JSON.decode(File.read('db/seed_files/conference.json'))
conference.each do |e|
  Conference.create(:name=>e['name'], :kp_name=>e['kp_name'], :bmat_name=>e['bmat_name'])
end

#seed the rounds
rounds = ActiveSupport::JSON.decode(File.read('db/seed_files/rounds.json'))
rounds.each do |round|
  Round.create(:number => round["number"], :name => round["name"])
end

#seed the regions
regions = ActiveSupport::JSON.decode(File.read('db/seed_files/regions.json'))
regions.each do |region|
  Region.create(:name => region["region"])
end


#get tournament data
tournaments = ActiveSupport::JSON.decode(File.read('db/seed_files/tournament.json'))
#loop through each tournament
tournaments.each do |e|
  year = e["year"]
  tournament = Tournament.create(:name=>e['name'], :date => e['date'], :year=>e['year'])
  
  #crawl the bracketmatrix site
  @crawler.bracketMatrixCrawler(year)
  @crawler.bmat_team_data.each do |key, row|
    name = row["name"]
    clean_name = row["name"][/[^\d]+/].rstrip.downcase
    
    bmat_team = BmatrixTeam.find_by name: clean_name
    if(bmat_team.nil?)
      bmat_team = BmatrixTeam.create(:name => clean_name, :conf => row["conf"])
    end
    
    BmatrixStat.create( :bmatrix_team_id => bmat_team.id, :tournament_id => tournament.id, :rank => row["rank"], :avg_seed=>row["avg_seed"]) 
  end 
  
  #crawl the kenpom site
  @crawler.kenPomCrawler(year)
  @crawler.kp_team_data.each do |key, row| 
    name = row["team"]
    clean_name = row["team"][/[^\d]+/].rstrip.downcase
    
    #store the seed in a hash
    seed =  name.scan( /\d+$/ ).first.to_i
    seeds[clean_name] = seed
    kp_team = KenpomTeam.find_by name: clean_name
    if(kp_team.nil?)
      kp_team = KenpomTeam.create(:name => clean_name, :conf => row["conf"])
    end
    KenpomStat.create(:kenpom_team_id => kp_team.id, :tournament_id => tournament.id, :rank => row["rank"],:wl => row["w-l"],:pyth => row["pyth"],
    :adjo => row["adjo"],:adjd => row["adjd"],:adjt => row["adjt"],:luck => row["luck"],:pyth_sched => row["pyth_sched"],
    :oppo_sched => row["oppo_sched"],:oppd_sched => row["oppd_sched"],:pyth_ncsos => row["pyth_ncsos"]) 
  end 
 
end

teams = ActiveSupport::JSON.decode(File.read('db/seed_files/team.json'))
teams.each do |e|
  kp = KenpomTeam.find_by name: (e['kp_name'].downcase)
  bmat = BmatrixTeam.find_by name: (e['bmat_name'].downcase)
  conf = Conference.find_by kp_name: kp.conf
  new_team = Team.create(:name=>e['name'].downcase, :conference_id => conf.id, :kenpom_team=>kp, :bmatrix_team=>bmat)
end

bracket_games = ActiveSupport::JSON.decode(File.read('db/seed_files/tournament_matches.json'))
bracket_games.each do |game|
  BracketGame.create(:tournament_id => game["tournament_id"], :round_id => game["round_id"], 
  :region_id => game["region_id"], :team_id => game["team_id"], :team2_id => game["team2_id"], 
  :weight => game["weight"], :winner_id => game["winner_id"])
  
end

