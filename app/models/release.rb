class Release < ActiveRecord::Base
  attr_accessible :description, :download_url, :name, :source_url, :user_id, :release, :downloads
  
  belongs_to :user
end
