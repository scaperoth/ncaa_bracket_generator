# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

#create a new crawler object
@crawler = Crawler.new

#crawl the kenpom site
@crawler.kenPomCrawler 
@crawler.kp_team_data.each do |key, row| 
   KenpomTeam.create(:name => row["team"][/[^\d]+/].rstrip.downcase, :rank => row["rank"], :conf => row["conf"],:wl => row["w-l"],:pyth => row["pyth"],:adjo => row["adjo"],:adjd => row["adjd"],:adjt => row["adjt"],:luck => row["luck"],:pyth_sched => row["pyth_sched"],:oppo_sched => row["oppo_sched"],:oppd_sched => row["oppd_sched"],:pyth_ncsos => row["pyth_ncsos"]) 
end 

#crawl the bracketmatrix site
@crawler.bracketMatrixCrawler
@crawler.bmat_team_data.each do |key, row| 
   BmatrixTeam.create(:name => row["name"][/[^\d]+/].rstrip.downcase, :rank => row["rank"], :conf => row["conf"], :avg_seed=>row["avg_seed"]) 
end 

conference = ActiveSupport::JSON.decode(File.read('db/seed_files/conference.json'))
conference.each do |e|
  Conference.create(:name=>e['name'], :kp_name=>e['kp_name'], :bmat_name=>e['bmat_name'])
end

team = ActiveSupport::JSON.decode(File.read('db/seed_files/team.json'))
team.each do |e|
  kp = KenpomTeam.find_by name: e['kp_name']
  bmat = BmatrixTeam.find_by name: e['bmat_name']
  Team.create(:name=>e['name'], :kenpom_team=>kp, :bmatrix_team=>bmat)
end

tournament= ActiveSupport::JSON.decode(File.read('db/seed_files/tournament.json'))
tournament.each do |e|
  Team.create(:year=>e['year'])
end
