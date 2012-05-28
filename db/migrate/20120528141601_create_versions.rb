class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :release_id
      t.integer :version_number
      t.string :download_url
      t.integer :downloads, :default => 0

      t.timestamps
    end
  end
end
