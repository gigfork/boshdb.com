class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.string :name
      t.text :description
      t.string :source_url
      t.integer :user_id
      t.float :rating, :default => 0.0
      t.integer :downloads, :default => 0

      t.timestamps
    end
  end
end
