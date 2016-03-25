class CreateKenpomTeams < ActiveRecord::Migration
  def change
    create_table :kenpom_teams do |t|
      t.integer :rank
      t.string :name
      t.string :conf
      t.string :wl
      t.decimal :pyth
      t.decimal :adjO
      t.decimal :adjD
      t.decimal :adjT
      t.decimal :Luck
      t.decimal :pyth_sched
      t.decimal :oppO_sched
      t.decimal :oppD_sched
      t.decimal :pyth_ncsos

      t.timestamps
    end
    add_index :kenpom_teams, :rank
  end
end
