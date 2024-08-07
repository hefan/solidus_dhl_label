# Solidus Dhl Label

DHL Shipping Label PDF Creation for Solidus Shop.

Create a Shipping Label for each completed order using the DHL "Parcel DE Shipping (Post & Parcel Germany)" API.

Tested for solidus 3.4 and above.

## Extension Installation

Add solidus_dhl_label to your Gemfile:

```ruby
gem 'solidus_dhl_label', github: "hefan/solidus_dhl_label"
```

Bundle your dependencies:

```ruby
bundle install
```

Install the Extension:

```ruby
bundle exec rails g solidus_dhl_label:install
```


## Extension Usage

### Configure

Configure your Settings in _config/initializers/solidus_dhl_label_rb_

```ruby
SolidusDhlLabel.configure do |config|
  config.endpoint = ""
  config.bcs_user = ""
  config.bcs_password = ""
  config.ekp = ""
  config.procedure_id = ""
  config.participation_id = ""
  config.api_key = ""
  config.consignor = {  
    name1: "",
    name2: "",
    addressStreet: "",
    postalCode: "",
    city: "",
    country: "",
    email: ""
  }
  config.default_unit_weight = 1.0 # default weight if weight for variant is not given
  config.debug_output = false # log request and response output for debugging
end
```

#### Explanation of configuration

* __endpoint__: URL Endpoint of the Service
  * Sandbox/test: https://api-sandbox.dhl.com/parcel/de/shipping/v2/orders?includeDocs=URL
  * Production: https://api-eu.dhl.com/parcel/de/shipping/v2/orders?includeDocs=URL


* __bcs_user__ and __bcs_password__ your credentials as Business Consumer at DHL Business Consumer Portal https://geschaeftskunden.dhl.de/
  * For _Sandbox_ you can use __"sandy_sandbox"__ and __"pass"__


* __ekp__: "uniform customer and product number" from your Business Consumer Profile.   
  * For _Sandbox_ you can use __"3333333333"__


* __procedure_id__: "Contract Procedure" ID, does als stand for selected DHL Product.
  * More detailed description in https://developer.dhl.com/api-reference/parcel-de-shipping-post-parcel-germany-v2?lang=en#get-started-section/ Section "Products and services via the web service interface"
  * For example __"01"__ for __"V01PAK"__ (germany only) product, __"53"__ for __"V53WPAK"__ (worldwide) product
  * __"auto"__ does select __"01"__ or __"53"__ based on orders ship address


* __participation_id__: "contract participation" ID, you will get it from your Business Consumer Profile.
  * For _Sandbox_ you can just use __"01"__


* __api_key__: Your API Key from the credentials of your created app at the developer portal https://developer.dhl.com/
  * The app needs to have the API of type _Parcel DE Shipping (Post & Parcel Germany)_ assigned. Watch for the environment: test(sandbox) or production.
  * the _api_secret_ seems not to be needed!


* __consignor__: The Sender Address for the Label. Normally the Address of your Business
  * __name1__
  * __name2__: optional second name
  * __addressStreet__
  * __postalCode__
  * __city__
  * __country__: in iso3 format, like "DEU" for germany
  * __email__


* __default_unit_weight__: Weight is needed for the package, at least 0.01 kg, max 31.5 kg.
  * if your variants doesn't have weight (or have 0.0, which isn't sufficient for being able to print the label), the weight given here will be used
  * the weight for the label request will be the sum from the orders line items and their quantity.
  * You can als add dimensions to the request. if you need to do that, you have to override the _get_shipments_ function in _Spree::DhlLabelService_, see also https://developer.dhl.com/api-reference/parcel-de-shipping-post-parcel-germany-v2?lang=en#get-started-section/ Section "Dimensions"


* __debug_output__: _true_ or _false_. if true the request and response will be logged.


### further info resources

Usage of the DHL Parcel DE Shipping API, description of services and postman collection to test:
https://developer.dhl.com/api-reference/parcel-de-shipping-post-parcel-germany-v2?lang=en#get-started-section/

DHL Developer Portal
https://developer.dhl.com/

DHL Busines Consumer Portal
https://geschaeftskunden.dhl.de/


### Usage in Backend

Push the "DHL Label" Button on the orders detail page in shipments tab to send the label request and to get either redirected to the label url or to get a flash with the error message from the response.

## Development

### Testing the extension

First bundle your dependencies, then run `bin/rake`. `bin/rake` will default to building the dummy
app if it does not exist, then it will run specs. The dummy app can be regenerated by using
`bin/rake extension:test_app`.

```shell
bin/rake
```

To run [Rubocop](https://github.com/bbatsov/rubocop) static code analysis run

```shell
bundle exec rubocop
```

When testing your application's integration with this extension you may use its factories.
You can load Solidus core factories along with this extension's factories using this statement:

```ruby
SolidusDevSupport::TestingSupport::Factories.load_for(SolidusDhlLabel::Engine)
```

### Running the sandbox

To run this extension in a sandboxed Solidus application, you can run `bin/sandbox`. The path for
the sandbox app is `./sandbox` and `bin/rails` will forward any Rails commands to
`sandbox/bin/rails`.

Here's an example:

```
$ bin/rails server
=> Booting Puma
=> Rails 6.0.2.1 application starting in development
* Listening on tcp://127.0.0.1:3000
Use Ctrl-C to stop
```

### Releasing new versions

Please refer to the [dedicated page](https://github.com/solidusio/solidus/wiki/How-to-release-extensions) in the Solidus wiki.

## License

Copyright (c) 2024 stefan hartmann, released under the New BSD License.
