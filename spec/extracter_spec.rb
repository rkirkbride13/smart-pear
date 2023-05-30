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
end
