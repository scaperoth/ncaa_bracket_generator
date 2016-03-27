class CreateBmatrixTeams < ActiveRecord::Migration
  def change
    create_table :bmatrix_teams do |t|
      t.integer :rank
      t.string :name
      t.string :conf
      t.decimal :avg_seed
      t.has_one :team_name
      t.timestamps
    end
    add_index :bmatrix_teams, :id
  end
end
