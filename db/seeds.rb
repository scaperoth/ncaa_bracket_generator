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

#crawl the kenpom site
@crawler.kenPomCrawler 
@crawler.kp_team_data.each do |key, row| 
  name = row["team"]
  clean_name = row["team"][/[^\d]+/].rstrip.downcase
  
  #store the seed in a hash
  seed =  name.scan( /\d+$/ ).first.to_i
  seeds[clean_name] = seed
  
  KenpomTeam.create(:name => clean_name, :rank => row["rank"], :conf => row["conf"],:wl => row["w-l"],:pyth => row["pyth"],:adjo => row["adjo"],:adjd => row["adjd"],:adjt => row["adjt"],:luck => row["luck"],:pyth_sched => row["pyth_sched"],:oppo_sched => row["oppo_sched"],:oppd_sched => row["oppd_sched"],:pyth_ncsos => row["pyth_ncsos"]) 
end 

#crawl the bracketmatrix site
@crawler.bracketMatrixCrawler
@crawler.bmat_team_data.each do |key, row|
  name = row["name"]
  clean_name = row["name"][/[^\d]+/].rstrip.downcase
  
  BmatrixTeam.create(:name => clean_name, :rank => row["rank"], :conf => row["conf"],:avg_seed=>row["avg_seed"]) 
end 

conference = ActiveSupport::JSON.decode(File.read('db/seed_files/conference.json'))
conference.each do |e|
  Conference.create(:name=>e['name'], :kp_name=>e['kp_name'], :bmat_name=>e['bmat_name'])
end

tournament_teams = Array.new

team = ActiveSupport::JSON.decode(File.read('db/seed_files/team.json'))
team.each do |e|
  kp = KenpomTeam.find_by name: (e['kp_name'].downcase)
  bmat = BmatrixTeam.find_by name: (e['bmat_name'].downcase)
  new_team = Team.create(:name=>e['name'].downcase, :kenpom_team=>kp, :bmatrix_team=>bmat)
  tournament_teams.push(new_team)
end

tournaments = Array.new

tournament= ActiveSupport::JSON.decode(File.read('db/seed_files/tournament.json'))
tournament.each do |e|
  tournament = Tournament.create(:name=>e['name'], :year=>e['year'])
  tournaments.push(tournament)
end

tournament_teams.each do |tournament_team|
  tt = TournamentTeam.create(:tournament => tournaments[0], :team=>tournament_team)
end

