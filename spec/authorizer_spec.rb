require 'rspec'
require 'google/apis/drive_v3'
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
end
