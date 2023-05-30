require 'rspec'
require 'file_downloader'

describe FileDownloader do
  describe '#save_sheet_locally' do
    it 'saves a spreadsheet locally' do
      auth = double('GoogleCloudAuthorizer')
      credentials = double('Google::Auth::UserAuthorizer')
      sheet_id = '12345'
      drive_service = double('Google::Apis::DriveV3::DriveService')
      sheet_name = 'mock_sheet'
      file_path = "./files/#{sheet_name}"
      user_id = 'default'
      oauth_base_url = 'urn:ietf:wg:oauth:2.0:oob'

      allow(auth).to receive(:get_api_credentials).and_return(credentials)
      allow(auth).to receive(:sheet_id).and_return(sheet_id)
      
      extracter = FileDownloader.new(auth, user_id, oauth_base_url)

      allow(Google::Apis::DriveV3::DriveService).to receive(:new).and_return(drive_service)
      expect(drive_service).to receive(:authorization=).with(credentials)
      expect(drive_service).to receive(:get_file).with(sheet_id, download_dest: file_path)
      
      expect { extracter.save_sheet_locally(sheet_name, file_path) }.to output("File saved as '#{sheet_name}'\n").to_stdout
    end
  end
end
