class Release < ActiveRecord::Base
  attr_accessible :description, :download, :name, :source, :user_id, :release
end
