class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :name
      t.string :kp_name
      t.string :bmat_name
      t.string :short_name
      t.timestamps
    end
  end
end
