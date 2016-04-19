class CreateGeneratedBracketGames < ActiveRecord::Migration
  def change
    create_table :generated_bracket_games do |t|

      t.timestamps
    end
  end
end
