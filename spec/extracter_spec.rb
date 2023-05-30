require 'rspec'
require 'extracter'

describe Extracter do
  
  before(:each) do
    @auth = double('APIAuthorizer')
    @credentials = double('Google::Auth::UserAuthorizer')
    @sheet_id = '12345'
  end

  describe '#initialize' do
    it 'initializes with credentials and sheet ID' do
      allow(@auth).to receive(:get_API_credentials).and_return(@credentials)
      allow(@auth).to receive(:sheet_id).and_return(@sheet_id)
    end
  end

  describe '#save_sheet_locally' do
    it 'saves a spreadsheet locally' do
      drive_service = double('Google::Apis::DriveV3::DriveService')
      sheet_name = 'mock_sheet'
      
      extracter = Extracter.new(@auth)

      allow(Google::Apis::DriveV3::DriveService).to receive(:new).and_return(drive_service)
      expect(drive_service).to receive(:authorization=).with(@credentials)
      expect(drive_service).to receive(:get_file).with(@sheet_id, download_dest: "./files/#{sheet_name}")
      
      expect { extracter.save_sheet_locally(sheet_name) }.to output("File saved as '#{sheet_name}'\n").to_stdout
    end
  end
end
