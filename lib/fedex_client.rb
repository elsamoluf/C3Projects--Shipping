class FedexClient
  attr_reader :fedex

  # USPS_SERVICES = ["USPS First-Class Mail Parcel", "USPS Priority Mail 1-Day"]

  def initialize
    @fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
  end

  def fetch_rates(shipment)
    origin = ActiveShipping::Location.new(country: "US", city: shipment["origin"]["city"], state: shipment["origin"]["state"], zipcode: shipment["origin"]["zipcode"])

    destination = ActiveShipping::Location.new(country: "US", city: shipment["origin"]["city"], state: shipment["origin"]["state"], zipcode: shipment["origin"]["zipcode"])

    passed_packages = shipment["packages"]

    # packages = []
    # passed_packages.each do |package|
    #   a_package = ActiveShipping::Package.new(package["weight"], package["dimensions"])
      passed_packages = ActiveShipping::Package.new(package["weight"], package["dimensions"])
      packages = passed_packages

      # packages << a_package
    # end

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
