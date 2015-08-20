require 'active_shipping'
class FedexClient
  attr_reader :fedex

  # USPS_SERVICES = ["USPS First-Class Mail Parcel", "USPS Priority Mail 1-Day"]

  def initialize
    @fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
  end

  def fetch_rates(shipment)
    origin = ActiveShipping::Location.new(country: "US", city: shipment["origin"]["city"], state: shipment["origin"]["state"], postal_code: shipment["origin"]["postal_code"])

    destination = ActiveShipping::Location.new(country: "US", city: shipment["destination"]["city"], state: shipment["destination"]["state"], postal_code: shipment["destination"]["postal_code"])


    packages = ActiveShipping::Package.new(shipment["packages"]["weight"], shipment["packages"]["dimensions"])

    # a_package = ActiveShipping::Package.new(shipment["packages"].first["weight"], shipment["packages"].first["dimensions"])
    # packages = []
    # packages << a_package



    response = fedex.find_rates(origin, destination, packages)
    rates = response.rates

    # ## collect only the desired service rates
    # collected_rates = []
    # rates.each do |rate|
    #   collected_rates << rate if USPS_SERVICES.include?(rate.service_name)
    # end
    #
    # ## pull out just the service_name and calculate the total rate
    # rate_price_pairs = []
    # collected_rates.each do |rate|
    #   collected_prices = 0
    #   rate.package_rates.each do |package_rate|
    #     collected_prices += package_rate[:rate]
    #   end
    #   rate_price_pairs << {
    #     service_name: rate.service_name, total_price: collected_prices
    #   }
    # end
    # return rate_price_pairs
    return rates
  end
end
