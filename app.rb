require_relative './lib/authorizer'
require_relative './lib/extracter'
require_relative './lib/transformer'

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
    @auth = APIAuthorizer.new('./config/client_secret.json', @sheet_id)
    @auth.create_authorizer
    @auth.get_API_credentials
  end

  def extract_sheet
    extract = Extracter.new(@auth)
    extract.save_sheet_locally(@download_name)
  end

  def transform_data
    transform = Transformer.new("./files/#{@download_name}")
    transform.transform_excel_spreadsheet
    transform.save_nested_hash_to_file('./files/nested_hash.rb')
  end

end

ScriptRunner.new('1JbGMS3p5dzHrOdGptBPzm9aZhpHiVNVt', 'central_products_list.xlsm').run