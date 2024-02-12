module Spree
  class DhlLabelService

    include Singleton

    def initialize
      service_url = URI(SolidusDhlLabel::config.endpoint)
      @https = Net::HTTP.new(service_url.host, service_url.port)
      @https.use_ssl = true
      @https.set_debug_output($stdout) if SolidusDhlLabel::config.debug_output

      @request = Net::HTTP::Post.new(service_url)
      @request.basic_auth SolidusDhlLabel::config.bcs_user, SolidusDhlLabel::config.bcs_password
      @request["dhl-api-key"] = SolidusDhlLabel::config.api_key
      @request["Content-Type"] = "application/json"
    end

    def fetch_shipping_label order
      @request.body = JSON.dump({
        profile: "STANDARD_GRUPPENPROFIL",
        shipments: get_shipments(order)
      })
      response = @https.request(@request)

      rbody = JSON.parse(response.read_body)
      if rbody["status"] == 401
        raise Net::HTTPBadResponse.new I18n.t("spree.dhl_label.unauthorized")
      elsif rbody["status"] == 500
        raise Net::HTTPBadResponse.new I18n.t("spree.dhl_label.missing_package_details")
      elsif rbody["status"]["statusCode"] > 299
        raise Net::HTTPBadResponse.new(I18n.t("spree.dhl_label.package_error")+": #{rbody["items"][0]["validationMessages"].inspect}")
      end
      return rbody['items'][0]['label']['url']
    end

    private

    def get_shipments order
      procedure_id = select_procedure_id(order,SolidusDhlLabel::config.procedure_id)
      [{
        product: procedure_product_map(procedure_id),
        billingNumber: SolidusDhlLabel::config.ekp +
          procedure_id +
          SolidusDhlLabel::config.participation_id,
        refNo: order.number,
        shipper: SolidusDhlLabel::config.consignor,
        consignee: get_consignee(order),
        details: {
          weight: {
            uom: "kg",
            value: order.line_items.sum { |li|
              li.quantity * ((li.variant.weight > 0.0) ? li.variant.weight : SolidusDhlLabel::config.default_unit_weight)
            }
          }
        }
      }]
    end

    def select_procedure_id order, config_procedure_id
      if config_procedure_id.eql? "auto"
        if order.ship_address.country.iso3.eql? "DEU"
          return "01"
        else
          return "53"
        end
      else
        return config_procedure_id
      end
    end

    def get_consignee order
      consignee = {
        name1: order.ship_address.company.present? ? order.ship_address.company : order.ship_address.name,
        name2: order.ship_address.company.present? ? order.ship_address.name : nil,
        addressStreet: order.ship_address.address1,
        additionalAddressInformation1: order.ship_address.address2.present? ? order.ship_address.address2 : nil,
        postalCode: order.ship_address.zipcode.strip,
        city: order.ship_address.city,
        country: order.ship_address.country.iso3,
        email: order.email,
      }
    end

    def procedure_product_map procedure_id
      case procedure_id
        when "01"
          return "V01PAK"
        when "53"
          return "V53WPAK"
        when "54"
          return "V54EPAK"
        when "62"
          return "V62WP"
        when "66"
          return "V66WPI"
        else
          return nil
      end
    end

  end
end
