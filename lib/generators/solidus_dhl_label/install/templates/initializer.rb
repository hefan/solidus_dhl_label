# frozen_string_literal: true

SolidusDhlLabel.configure do |config|
  config.endpoint = "https://api-sandbox.dhl.com/parcel/de/shipping/v2/orders?includeDocs=URL"
  config.bcs_user = "sandy_sandbox"
  config.bcs_password = "pass"
  config.ekp = "3333333333"
  config.procedure_id = "auto"
  config.participation_id = "01"
  config.api_key = ""

  config.consignor = {  #
    name1: "",
    name2: "",
    addressStreet: "",
    postalCode: "",
    city: "",
    country: "",
    email: ""
  }
  config.default_unit_weight = 1.0
  config.debug_output = false
end
