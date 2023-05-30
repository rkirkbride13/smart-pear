# Smart Pear tech test

This is my attempt at a tech test for Kraken Smart Pear. It was written using Ruby and test-driven with the RSpec framework

## Specification

### Requirements

Using a ruby script only, turn the data in the last worksheet of the attached workbook in to a nested Hash where:

- the outermost keys are the values for column D (Device_Type.name)
- the next outermost are the corresponding values for column E (Device_Model.manufacturer_identifier)
- the next outermost are the corresponding values for column I (Device_Model.model_identifier_concatenated_with_hardware_version)
- the corresponding values at the innermost level are each a hash composed as:
  { firmware_version: the value in column J (Device_Model.firmware_version),
  smets_chts_version: the value in column K (SMETS_CHTS
  Version.Version_number_and_effective_date),
  gbcs_version:  the value in column L (GBCS Version.version_number),
   image_hash: the value in column M (Manufacturer_Image.hash) }

The data from all rows in the worksheet must be included in the Hash, except those marked "Removed" in column C, which must be excluded.

Add comments to explain your solution and why you believe it is optimal
