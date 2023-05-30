require 'rspec'
require 'roo'
require 'CPL_mapper'

RSpec.describe CPLMapper do
  before(:each) do
    @file_path = File.join(__dir__, 'mock_sheet.xlsm')
    @transformer = CPLMapper.new
  end

  describe '#map_to_nested_hash' do
    it 'transforms the spreadsheet into a nested hash' do
      transformed_data = @transformer.map_to_nested_hash(@file_path)
      mock_hash = {
        "Communications Hub" => {
          "106C" => {
            "433100AC" => [
              { :firmware_version => "124074DA",
               :smets_chts_version => "CHTS V1.0 ",
               :gbcs_version => "GBCS Version 1.0 ",
               :image_hash => "137ED5BC81A21F6D2187BC380381AEA7705BF65D3E4DAEA28EFD44113079D5E9" }] } } }
      
      expect(transformed_data).to be_a(Hash)
      expect(transformed_data).to eq(mock_hash)
    end
  end

  describe '#save_nested_hash_to_file' do
    before do
      @transformer.map_to_nested_hash(@file_path)
      @output_path = File.join(__dir__, 'mock_nested_hash.rb')
      @transformer.save_nested_hash_to_file(@output_path)
    end

    it 'saves the nested hash to a file' do
      expect(File.exist?(@output_path)).to be_truthy
    end

    it 'saves correct data to the file' do
      file_content = File.read(@output_path)
      expected_content = "nested_hash = #{@transformer.instance_variable_get(:@nested_hash).inspect}\n"

      expect(file_content).to eq(expected_content)
      expect { @transformer.save_nested_hash_to_file(@output_path) }.to output("Nested hash saved as 'nested_hash.rb'\n").to_stdout
    end
  end
end
