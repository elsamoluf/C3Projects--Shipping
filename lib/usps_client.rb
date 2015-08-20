class UspsClient
  attr_reader :usps

  # USPS_SERVICES = ["USPS First-Class Mail Parcel", "USPS Priority Mail 1-Day"]

  def initialize
    @usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], test: true)
  end

  def fetch_rates(shipment)
    origin = ActiveShipping::Location.new(country: "US", city: shipment["origin"]["city"], state: shipment["origin"]["state"], postal_code: shipment["origin"]["postal_code"])

    destination = ActiveShipping::Location.new(country: "US", city: shipment["destination"]["city"], state: shipment["destination"]["state"], postal_code: shipment["destination"]["postal_code"])

    packages = ActiveShipping::Package.new(shipment["packages"]["weight"], shipment["packages"]["dimensions"])

    # # packages = []
    # # passed_packages.each do |package|
    # #   a_package = ActiveShipping::Package.new(package["weight"], package["dimensions"])
    #   passed_packages = ActiveShipping::Package.new(packages["weight"], packages["dimensions"])
    #   packages = passed_packages
    #   # packages << a_package
    # # end

    response = usps.find_rates(origin, destination, packages)
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
