class Teams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :conf
      t.belongs_to :kenpom_team, index: true
      t.belongs_to :bmatrix_team, index: true

      t.timestamps
    end
    add_index :team_names, :id
  end
end
