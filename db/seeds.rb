# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

@crawler = Crawler.new("http://localhost:3000/test/kenpom") 
@crawler.team_data.each do |key, row| 
   KenpomTeam.create(:name => row["team"][/[^\d]+/].rstrip.downcase, :rank => row["rank"], :conf => row["conf"],:wl => row["w-l"],:pyth => row["pyth"],:adjo => row["adjo"],:adjd => row["adjd"],:adjt => row["adjt"],:luck => row["luck"],:pyth_sched => row["pyth_sched"],:oppo_sched => row["oppo_sched"],:oppd_sched => row["oppd_sched"],:pyth_ncsos => row["pyth_ncsos"]) 
end 
