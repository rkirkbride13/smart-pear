require 'rspec'
require 'roo'
require 'transformer'

RSpec.describe Transformer do

  describe '#transform_excel_spreadsheet' do
    it 'transforms the spreadsheet into a nested hash' do
      @file_path = File.join(__dir__, 'mock_sheet.xlsm')
      @transformer = Transformer.new(@file_path)
      transformed_data = @transformer.transform_excel_spreadsheet

      mock_hash = {
        "Communications Hub"=>{
          "106C"=>{
            "433100AC"=>[
              {:firmware_version=>"124074DA",
               :smets_chts_version=>"CHTS V1.0 ",
               :gbcs_version=>"GBCS Version 1.0 ",
               :image_hash=>"137ED5BC81A21F6D2187BC380381AEA7705BF65D3E4DAEA28EFD44113079D5E9"}]}}}
      
      expect(transformed_data).to be_a(Hash)
      expect(transformed_data).to eq(mock_hash)
    end
  end
end
