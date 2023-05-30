require_relative './lib/GC_authorizer'
require_relative './lib/file_downloader'
require_relative './lib/CPL_mapper'

class ScriptRunner
  def initialize(sheet_id, download_name)
    @sheet_id = sheet_id
    @download_name = download_name
  end

  def run
    authorize_API
    extract_sheet
    transform_data
  end

  private

  def authorize_API
    @auth = GoogleCloudAuthorizer.new('./config/client_secret.json', @sheet_id)
    @auth.create_authorizer
    @auth.get_API_credentials
  end

  def extract_sheet
    extract = FileDownloader.new(@auth)
    extract.save_sheet_locally(@download_name)
  end

  def transform_data
    transform = CPLMapper.new
    transform.map_to_nested_hash("./files/#{@download_name}")
    transform.save_nested_hash_to_file('./files/nested_hash.rb')
  end

end

ScriptRunner.new('1JbGMS3p5dzHrOdGptBPzm9aZhpHiVNVt', 'central_products_list.xlsm').run
