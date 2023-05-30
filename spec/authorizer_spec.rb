require 'rspec'
require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'authorizer'

RSpec.describe APIAuthorizer do
  before(:each) do
    @credentials_path = './config/client_secret.json'
    @sheet_id = '12345'
    @auth = APIAuthorizer.new(@credentials_path, '12345')
  end

  describe '#when initialized' do
    it 'assigns the sheet ID' do
      expect(@auth.sheet_id).to eq('12345')
    end
  end

  describe '#create_authorizer' do
    it 'creates authorizer with the correct credentials' do
      expect(Google::Auth::ClientId).to receive(:from_file).with(@credentials_path).and_return('client_id')
      expect(Google::Auth::Stores::FileTokenStore).to receive(:new).with(file: './config/token.json').and_return('token_store')
      expect(Google::Auth::UserAuthorizer).to receive(:new).with('client_id', Google::Apis::DriveV3::AUTH_DRIVE, 'token_store').and_return('authorizer')

      @auth.create_authorizer

      expect(@auth.instance_variable_get(:@authorizer)).to eq('authorizer')
    end
  end  
end
