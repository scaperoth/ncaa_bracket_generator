class CreateKenpomTeams < ActiveRecord::Migration
  def change
    create_table :kenpom_teams do |t|
      t.integer :rank
      t.string :name
      t.string :conf
      t.string :wl
      t.decimal :pyth
      t.decimal :adjo
      t.decimal :adjd
      t.decimal :adjt
      t.decimal :luck
      t.decimal :pyth_sched
      t.decimal :oppo_sched
      t.decimal :oppd_sched
      t.decimal :pyth_ncsos
      t.has_one :team_name

      t.timestamps
    end
    add_index :kenpom_teams, :id
  end
end
