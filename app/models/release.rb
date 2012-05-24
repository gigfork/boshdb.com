class Release < ActiveRecord::Base
  attr_accessible :description, :download, :name, :source
end
