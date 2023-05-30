require 'google/apis/drive_v3'

class Extracter
  def initialize(authorizeAPI)
    @credentials = authorizeAPI.get_API_credentials
    @sheet_id = authorizeAPI.sheet_id
  end

  def save_sheet_locally(sheet_name)
    # Initialize Google Drive API client
    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.authorization = @credentials
    # Save the Google Sheet file
    file = drive_service.get_file(@sheet_id, download_dest: "./files/#{sheet_name}")
    puts "File saved as '#{sheet_name}'"
  end
end