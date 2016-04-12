ActiveAdmin.register BracketGame do
  permit_params :tournament_id, :team_id, :team2_id, :round_id, :region_id, :weight, :winner_id
end