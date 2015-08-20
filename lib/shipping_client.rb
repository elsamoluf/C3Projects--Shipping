class ShippingClient
  def self.create_packages(passed_packages)
    # packages = []
    # passed_packages.each do |package|
      # a_package = ActiveShipping::Package.new(package["weight"], package["dimensions"])
      passed_packages = ActiveShipping::Package.new(package["weight"], package["dimensions"])
      packages = passed_packages
      # packages << a_package
    # end
    # return packages
  end

  def self.create_location(passed_location)
    ActiveShipping::Location.new(country: "US", state: location["state"], city: location["city"], zipcode: location["zipcode"])
  end
end
