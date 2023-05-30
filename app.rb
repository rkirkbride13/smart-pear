require_relative './lib/gc_authorizer'
require_relative './lib/file_downloader'
require_relative './lib/cpl_mapper'

class ScriptRunner
  def initialize(
    credentials_path, 
    sheet_id, 
    token_path, 
    user_id, 
    oauth_base_url, 
    download_name, 
    download_path, 
    hash_path)

    @credentials_path = credentials_path
    @sheet_id = sheet_id
    @user_id = user_id
    @token_path = token_path
    @oauth_base_url = oauth_base_url
    @download_name = download_name
    @download_path = download_path
    @hash_path = hash_path
  end

  def run
    @auth = GoogleCloudAuthorizer.new(@credentials_path, @sheet_id)
    authorize_api
    @download_file = FileDownloader.new(@auth, @user_id, @oauth_base_url)
    download_sheet
    @map_data = CPLMapper.new
    map_sheet_data
  end

  private

  def authorize_api
    @auth.create_authorizer(@token_path)
    @auth.get_api_credentials(@user_id, @oauth_base_url)
  end

  def download_sheet
    @download_file.save_sheet_locally(@download_name, @download_path)
  end

  def map_sheet_data
    @map_data.map_to_nested_hash(@download_path)
    @map_data.save_nested_hash_to_file(@hash_path)
  end

end

credentials_path = './config/client_secret.json'
sheet_id = '1JbGMS3p5dzHrOdGptBPzm9aZhpHiVNVt'
token_path = './config/token.json'
user_id = 'default'
oauth_base_url = 'urn:ietf:wg:oauth:2.0:oob'
download_name = 'central_products_list.xlsm'
download_path = "./files/#{download_name}"
hash_path = './files/nested_hash.rb'

ScriptRunner.new(
  credentials_path, 
  sheet_id, 
  token_path, 
  user_id, 
  oauth_base_url, 
  download_name, 
  download_path, 
  hash_path
).run
