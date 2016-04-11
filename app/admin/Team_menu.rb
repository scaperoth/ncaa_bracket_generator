ActiveAdmin.register Team do
  permit_params :name, :conference_id, :kenpom_team_id, :bmatrix_team_id
  menu :parent => "Team Data"
end

ActiveAdmin.register KenpomTeam do
  permit_params :name,:conf
  menu :parent => "Team Data"
end

ActiveAdmin.register KenpomStat do
  permit_params :team_id, :tournament_id, :rank, :wl, :pyth,:adjo, :adjd , :adjt, :luck, :pyth_sched, :oppo_sched, :oppd_sched, :pyth_ncsos
  menu :parent => "Team Data"
end

ActiveAdmin.register BmatrixTeam do
  permit_params :name,:conf
  menu :parent => "Team Data"
end

ActiveAdmin.register BmatrixStat do
  permit_params :team_id, :tournament_id, :rank, :avg_seed
  menu :parent => "Team Data"
end
