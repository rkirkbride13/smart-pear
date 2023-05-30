require 'google/apis/drive_v3'

class APIAuthorizer
  attr_reader :sheet_id

  def initialize(credentials_path, sheet_id)
    # Path to the credentials JSON file obtained from the Google Cloud Console
    @credentials_path = credentials_path
    # ID of the Google Sheet file
    @sheet_id = sheet_id
    # Scope for the Google Drive API
    @scope = Google::Apis::DriveV3::AUTH_DRIVE
  end

end
