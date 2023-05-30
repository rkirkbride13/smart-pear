require 'rspec'
require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'GC_authorizer'

RSpec.describe GoogleCloudAuthorizer do
  before(:each) do
    @credentials_path = './config/client_secret.json'
    @sheet_id = '12345'
    @auth = GoogleCloudAuthorizer.new(@credentials_path, '12345')
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
  
  describe '#get_API_credentials' do
  
    before(:each) do
      client_id = instance_double('Google::Auth::ClientId')
      token_store = instance_double('Google::Auth::Stores::FileTokenStore')
      @authorizer = instance_double('Google::Auth::UserAuthorizer')
      allow(Google::Auth::ClientId).to receive(:from_file).with(@credentials_path).and_return(client_id)
      allow(Google::Auth::Stores::FileTokenStore).to receive(:new).with(file: './config/token.json').and_return(token_store)
      allow(Google::Auth::UserAuthorizer).to receive(:new).with(client_id, @auth.instance_variable_get(:@scope), token_store).and_return(@authorizer)
    end

    context 'when credentials do not exist' do
      it 'prompts for authorization and returns new credentials' do
        @auth.create_authorizer
        allow(@authorizer).to receive(:get_credentials).and_return(nil)
        allow(@authorizer).to receive(:get_authorization_url).and_return('http://authorization.url')
        allow(@authorizer).to receive(:get_and_store_credentials_from_code).and_return(instance_double('Google::Auth::Credentials'))
        allow_any_instance_of(Object).to receive(:gets).and_return('test_input')

        expect { @auth.get_API_credentials }.to output(/Open the following URL in your browser and authorize the application/).to_stdout
      end
    end

    context 'when credentials exist' do
      it 'returns credentials without prompting for authorization' do
        @auth.create_authorizer
        existing_credentials = instance_double('Google::Auth::Credentials')
        allow(@authorizer).to receive(:get_credentials).and_return(existing_credentials)
        expect(@auth.get_API_credentials).to eq(existing_credentials)
      end
    end
    
  end
end
