# Smart Pear tech test

This is my attempt at a tech test for Kraken Smart Pear. It was written using Ruby and test-driven with the RSpec framework.

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

### Approach

I initially set out to use the Google Sheets API to extract the data directly from the spreadsheet before transforming it as required. Having setup my OAuth 2.0 Client IDs on Google Cloud, I realised that I would need a different solution as the spreadsheet was saved as .xlsm and not as a Google Sheet, which limited the application of the Google Sheets API.

Therefore, I decided to instead extract the sheet using the Google Drive API and save it locally. From there I was able to much more easily start transforming the data. I settled on the Roo gem to transform the data in the desired worksheet into the required nested hash as it is better for .xlsm files than the Spreadsheet gem. Furthermore, I only needed to read the file which is the default for Roo.

I used a test-driven approach, starting with the APIAuthorizer class, then the Extractor and finally the Transformer.

### Future goals

Had I had more time I would've also implemented:

- Supplementary error handling
- A UserInterface class to allow the script to run with input from the command line.

## Setup

### OAuth 2.0 Credentials

For security reasons I have not included my OAuth 2.0 credentials in this package. Before running this script, the user will need to setup their own OAuth 2.0 Client ID on Google Cloud (see [help page](https://support.google.com/googleapi/answer/6158849?hl=en) if needed). Then these credentials can be downloaded and saved locally. Ensure that any file paths are updated according to the users needs.

### To run this code locally:

    $ git clone git@github.com:[USERNAME]/smart-pear.git
    $ gem install bundler
    $ bundle install
    $ ruby app.rb

**Important:** Ensure you update the variables sheet_id and download_name in `app.rb` to suite your specific needs

### To run the test suite

    $ git clone git@github.com:[USERNAME]/smart-pear.git
    $ gem install bundler
    $ bundle install
    $ rspec
