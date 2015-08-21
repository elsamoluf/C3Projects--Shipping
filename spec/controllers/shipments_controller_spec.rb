require 'rails_helper'
require 'fedex_client'
require 'usps_client'

RSpec.describe ShipmentsController, type: :controller do
  describe "GET #rates" do
    before :each do
      shipment = {
        shipment: {
          origin: {
            address1: "3320 James Rd",
            country: "US",
            city: "Keuka Park",
            state: "NY",
            postal_code: "14478"
          },
          destination: {
            address1: "1100 2nd Ave",
            country: "US",
            city: "Seattle",
            state: "WA",
            postal_code: "98101"
          },
          packages: {
            weight: 5,
            dimensions: [12, 12, 6]
          }
        }
      }
    # pass shipment object to API
    @json_shipment = shipment.to_json
    end

    it "is successful" do
      get :rates, json_data: @json_shipment

      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :rates, json_data: @json_shipment

      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "returns both carrier estimates together" do
      get :rates, json_data: @json_shipment
      rates = JSON.parse(response.body)
      carriers = []
      rates.each do |rate|
        carriers << rate["carrier"]
      end
      expect(carriers).to include(rates.first["carrier"], rates.last["carrier"])
    end
  end

end
