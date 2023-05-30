require 'rspec'
require 'google/apis/drive_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'gc_authorizer'

RSpec.describe GoogleCloudAuthorizer do
  before(:each) do
    @credentials_path = './config/client_secret.json'
    @sheet_id = '12345'
    @auth = GoogleCloudAuthorizer.new(@credentials_path, '12345')
    @token_path = './config/token.json'
  end

  describe '#when initialized' do
    it 'assigns the sheet ID' do
      expect(@auth.sheet_id).to eq('12345')
    end
  end

  describe '#create_authorizer' do
    it 'creates authorizer with the correct credentials' do
      expect(Google::Auth::ClientId).to receive(:from_file).with(@credentials_path).and_return('client_id')
      expect(Google::Auth::Stores::FileTokenStore).to receive(:new).with(file: @token_path).and_return('token_store')
      expect(Google::Auth::UserAuthorizer).to receive(:new).with('client_id', Google::Apis::DriveV3::AUTH_DRIVE, 'token_store').and_return('authorizer')

      @auth.create_authorizer(@token_path)

      expect(@auth.instance_variable_get(:@authorizer)).to eq('authorizer')
    end
  end
  
  describe '#get_API_credentials' do
  
    before(:each) do
      @user_id = 'default'
      @oauth_base_url = 'urn:ietf:wg:oauth:2.0:oob'
      client_id = instance_double('Google::Auth::ClientId')
      token_store = instance_double('Google::Auth::Stores::FileTokenStore')
      @authorizer = instance_double('Google::Auth::UserAuthorizer')
      allow(Google::Auth::ClientId).to receive(:from_file).with(@credentials_path).and_return(client_id)
      allow(Google::Auth::Stores::FileTokenStore).to receive(:new).with(file: @token_path).and_return(token_store)
      allow(Google::Auth::UserAuthorizer).to receive(:new).with(client_id, @auth.instance_variable_get(:@scope), token_store).and_return(@authorizer)
    end

    context 'when credentials do not exist' do
      it 'prompts for authorization and returns new credentials' do
        @auth.create_authorizer(@token_path)
        allow(@authorizer).to receive(:get_credentials).with(@user_id).and_return(nil)
        allow(@authorizer).to receive(:get_authorization_url).with(base_url: @oauth_base_url).and_return('http://authorization.url')
        allow(@authorizer).to receive(:get_and_store_credentials_from_code).and_return(instance_double('Google::Auth::Credentials'))
        allow_any_instance_of(Object).to receive(:gets).and_return('test_input')

        expect { @auth.get_api_credentials(@user_id, @oauth_base_url) }.to output(/Open the following URL in your browser and authorize the application/).to_stdout
      end
    end

    context 'when credentials exist' do
      it 'returns credentials without prompting for authorization' do
        @auth.create_authorizer(@token_path)
        existing_credentials = instance_double('Google::Auth::Credentials')
        allow(@authorizer).to receive(:get_credentials).with(@user_id).and_return(existing_credentials)
        expect(@auth.get_api_credentials(@user_id, @oauth_base_url)).to eq(existing_credentials)
      end
    end
    
  end
end
