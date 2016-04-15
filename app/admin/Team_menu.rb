ActiveAdmin.register Team do
  permit_params :name, :conference_id, :kenpom_team_id, :bmatrix_team_id
  menu :parent => "Team Data"
  index do
    selectable_column
    id_column
    column :name
    column :kenpom_team_id
    column :bmatrix_team_id
    column :conference_id
    actions
  end
end

ActiveAdmin.register KenpomTeam do
  permit_params :name,:conf
  menu :parent => "Team Data"
end

ActiveAdmin.register KenpomStat do
  permit_params :kenpom_team_id, :tournament_id, :rank, :wl, :pyth,:adjo, :adjd , :adjt, :luck, :pyth_sched, :oppo_sched, :oppd_sched, :pyth_ncsos
  menu :parent => "Team Data"
  
  index do
    selectable_column
    id_column
    column :tournament_id do |tournament_stats|
      tournament_stats.tournament.year
    end
    column :kenpom_team_id
    column :rank
    column :wl
    column :pyth
    column :adjo
    column :adjd
    column :adjt
    column :luck
    column :pyth_sched
    column :oppo_sched
    column :oppd_sched
    column :pyth_ncsos
    actions
  end
end

ActiveAdmin.register BmatrixTeam do
  permit_params :name,:conf
  menu :parent => "Team Data"
end

ActiveAdmin.register BmatrixStat do
  permit_params :bmatrix_team_id, :tournament_id, :rank, :avg_seed
  menu :parent => "Team Data"
  index do
    selectable_column
    id_column
    column :tournament_id do |tournament_stats|
      tournament_stats.tournament.year
    end
    column :bmatrix_team_id
    column :rank
    column :avg_seed
    actions
  end
end
