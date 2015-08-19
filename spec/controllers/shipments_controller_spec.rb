require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  describe "GET #index" do
    let(:packages) {
      packages = [
        ActiveShipping::Package.new( 100, [93,10], cylinder: true ),
        ActiveShipping::Package.new( 7.5 * 16, [15, 10, 4.5], units: :imperial )
      ]
    }
    let(:origin) {
      origin = ActiveShipping::Location.new(country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210')
    }
    let(:destination) {
      destination = ActiveShipping::Location.new(country: 'CA', province: 'ON', city: 'Ottawa', postal_code: 'K1P 1J1')
    }


    it "is successful" do
      origin
      destination
      packages
      get :index, origin: origin, destination: destination, packages: packages

      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :index, origin: origin, destination: destination, packages: packages

      expect(response.header['Content-Type']).to include 'application/json'
    end

    # it "returns fedex rate estimates" do
    #   fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
    #   response = fedex.find_rates(origin, destination, packages)
    #   fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    #
    #   expect(response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}).to eq fedex_rates
    # end
    #
    # it "return usps rate estimates" do
    #   usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], test: true)
    #   response = usps.find_rates(origin, destination, packages)
    #   usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    #
    #   expect(response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}).to eq usps_rates
    # end

    it "returns both carrier estimates together" do
      get :index, origin: origin, destination: destination, packages: packages

      expect(fedex_rates + usps_rates).to eq rates
    end
  end

end
