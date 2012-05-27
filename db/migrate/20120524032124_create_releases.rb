class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.text :description
      t.string :source
      t.string :download
      t.integer :user_id
      t.float :rating, :default => 0.0

      t.timestamps
    end
  end
end
