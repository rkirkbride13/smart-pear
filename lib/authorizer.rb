require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

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

  def create_authorizer
    # Initialize the OAuth client ID and client secret
    client_id = Google::Auth::ClientId.from_file(@credentials_path)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: './config/token.json')
    @authorizer = Google::Auth::UserAuthorizer.new(client_id, @scope, token_store)
  end

end
