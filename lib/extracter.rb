class Extracter
  def initialize(authorizeAPI)
    @credentials = authorizeAPI.get_API_credentials
    @sheet_id = authorizeAPI.sheet_id
  end
end