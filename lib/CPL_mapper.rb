require 'roo'

class CPLMapper
  def initialize
    @nested_hash = {}
  end

  def map_to_nested_hash(file_path)
    # Isolate the last sheet in the workbook
    workbook = Roo::Spreadsheet.open(file_path)
    worksheet = workbook.sheet(workbook.sheets.last)
    # Iterate over rows to create the nested hash
    (2..worksheet.last_row).each do |row_index|
      row = worksheet.row(row_index)
      next if row[2] == 'Removed' # Skip rows marked as 'Removed' in column C
      process_row(row)
    end

    return @nested_hash
  end

  def save_nested_hash_to_file(file_path)
    # Save the nested hash into a Ruby file
    file_content = "nested_hash = #{@nested_hash.inspect}"
    File.open(file_path, 'w') do |file|
      file.puts file_content
    end
    puts "Nested hash saved as '#{file_path}'"
  end

  private

  def process_row(row)
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
    firmware_hash = create_firmware_hash(
      firmware_version, smets_chts_version, gbcs_version, image_hash
    )

    # Append firmware hash to the innermost level array
    @nested_hash[device_type][manufacturer_identifier][model_identifier] << firmware_hash
  end

  def create_firmware_hash(firmware_version, smets_chts_version, gbcs_version, image_hash)
    {
      firmware_version: firmware_version,
      smets_chts_version: smets_chts_version,
      gbcs_version: gbcs_version,
      image_hash: image_hash
    }
  end

end
