ActiveAdmin.register BracketGame do
	permit_params :tournament_id, :team_id, :team1_score, :team2_id, :team2_score, :round_id, :region_id, :weight, :winner_id
	config.per_page = 100
	index do
		selectable_column
    id_column
		column :tournament_id do |tournament_game|
			tournament_game.tournament.year
		end
		column :team_id
		column :team2_id
    column :team1_score
		column :team2_score
		column :round_id
		column :region_id
		column :weight
		column :winner_id
		actions
	end
end