class Version < ActiveRecord::Base
  attr_accessible :version_number, :download_url, :downloads, :release_id
  
  belongs_to :release
end
