class CreateGeneratedBracketOptions < ActiveRecord::Migration
  def change
    create_table :generated_bracket_options do |t|

      t.timestamps
    end
  end
end
