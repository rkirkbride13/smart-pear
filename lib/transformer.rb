require 'roo'

class Transformer
  def initialize(file_path)
    @nested_hash = {}
    @file_path = file_path
  end

  def transform_excel_spreadsheet
    # Isolate the last sheet in the workbook
    workbook = Roo::Spreadsheet.open(@file_path)
    worksheet = workbook.sheet(workbook.sheets.last)
    # Iterate over rows to create the nested hash
    (2..worksheet.last_row).each do |row_index|
      row = worksheet.row(row_index)
      next if row[2] == 'Removed' # Skip rows marked as 'Removed' in column C

      device_type = row[3] # Column D
      manufacturer_identifier = row[4] # Column E
      model_identifier = row[8] # Column I
      firmware_version = row[9] # Column J
      smets_chts_version = row[10] # Column K
      gbcs_version = row[11] # Column L
      image_hash = row[12] # Column M

      # Create nested hash structure
      @nested_hash[device_type] ||= {}
      @nested_hash[device_type][manufacturer_identifier] ||= {}
      @nested_hash[device_type][manufacturer_identifier][model_identifier] ||= []

      # Create hash for each firmware version
      firmware_hash = {
        firmware_version: firmware_version,
        smets_chts_version: smets_chts_version,
        gbcs_version: gbcs_version,
        image_hash: image_hash
      }

      # Append firmware hash to the innermost level array
      @nested_hash[device_type][manufacturer_identifier][model_identifier] << firmware_hash
    end

    return @nested_hash
  end

end