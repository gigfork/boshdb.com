class VersionController < ApplicationController
  def download
    puts params.inspect
    
    release_id = params[:release_id]
    version_number = params[:version_number]
    
    @version = Version.where('version_number = ? AND release_id = ?', version_number, release_id).first
    
    # Increase the download count
    @version.downloads += 1
    @version.save
    
    redirect_to @version.download_url
  end
end
