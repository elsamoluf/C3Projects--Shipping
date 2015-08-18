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
      origin = ActiveShipping::Location.new( country:  'US', state: 'CA', city: 'Beverly Hills', zip: '90210')
    }
    let(:destination) {
      destination = ActiveShipping::Location.new( country:  'CA', province:  'ON', city:  'Ottawa', postal_code:  'K1P 1J1')
    }


    it "is successful" do
      get :index
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :index
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "returns rate estimates" do
      fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
      response = fedex.find_rates(origin, destination, packages)
      fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

      expect(response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}).to eq fedex_rates
    end
  end

end
