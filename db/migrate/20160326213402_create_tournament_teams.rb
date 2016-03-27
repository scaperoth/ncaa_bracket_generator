class CreateTournamentTeams < ActiveRecord::Migration
  def change
    create_table :tournament_teams do |t|
      t.references :team, index: true
      t.references :tournament, index: true

      t.timestamps
    end
  end
end
