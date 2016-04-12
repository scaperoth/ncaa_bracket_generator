class CreateTournamentMatches < ActiveRecord::Migration
  def change
    create_table :tournament_matches do |t|
      t.references :tournament, index: true
      t.references :region, index: true
      t.references :round, index: true
      t.references :team1, index: true
      t.references :team2, index: true
      t.integer :weight
      t.references :winner, index: true

      t.timestamps
    end
  end
end
