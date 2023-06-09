require 'google/apis/drive_v3'

class FileDownloader
  def initialize(gc_authorizer, user_id, oauth_base_url)
    @gc_authorizer = gc_authorizer
    @user_id = user_id
    @oauth_base_url = oauth_base_url
    @sheet_id = gc_authorizer.sheet_id
  end

  def save_sheet_locally(sheet_name, file_path)
    @credentials = @gc_authorizer.get_api_credentials(@user_id, @oauth_base_url)
    # Initialize Google Drive API client
    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.authorization = @credentials
    # Save the Google Sheet file
    file = drive_service.get_file(@sheet_id, download_dest: file_path)
    puts "File saved as '#{sheet_name}'"
  end
end
