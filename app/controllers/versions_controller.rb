class VersionsController < ApplicationController
  
  def download
    release_id = params[:release_id]
    version_number = params[:version_number]
    
    @version = Version.where('version_number = ? AND release_id = ?', version_number, release_id).first
    
    # Increase the download count
    @version.downloads += 1
    @version.save
    
    redirect_to @version.download_url
  end
  
  # POST /versions
  def create
    # Extract the parameters
    download_url = params[:version][:download_url]
    release_id = params[:release][:id]
    @release = Release.find_by_id(release_id)
    version_number = @release.versions.last.version_number + 1
    
    # Clean up the data
    download_url = "http://#{download_url}" if not download_url.starts_with? "http://" and not download_url.starts_with? "https://"
    
    # Make sure that the currently logged in user is the one adding the version
    if user_signed_in? && current_user.id == @release.user.id
      @version = Version.new
      @version.release_id = release_id
      @version.version_number = version_number
      @version.download_url = download_url
      @version.downloads = 0
      @version.save
    end
    
    redirect_to @release
  end
end
