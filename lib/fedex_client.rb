require 'active_shipping'
class FedexClient
  attr_reader :fedex

  def initialize
    @fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
  end

  def fetch_rates(shipment)
    origin = ActiveShipping::Location.new(country: "US", city: shipment["origin"]["city"], state: shipment["origin"]["state"], postal_code: shipment["origin"]["postal_code"], name: shipment["origin"]["name"], address1: shipment["origin"]["address1"])

    destination = ActiveShipping::Location.new(country: "US", city: shipment["destination"]["city"], state: shipment["destination"]["state"], postal_code: shipment["destination"]["postal_code"], name: shipment["destination"]["name"], address1: shipment["destination"]["address1"])


    packages = ActiveShipping::Package.new(shipment["packages"]["weight"], shipment["packages"]["dimensions"], :units => :imperial, :currency => "USD")

    response = fedex.find_rates(origin, destination, packages)
    rates = response.rates

    limited_rates = []
    rates.each do |rate|
      limited_rates << rate if rate.service_name == "FedEx 2 Day" || rate.service_name == "FedEx Ground Home Delivery"
    end

    return limited_rates
  end
end
