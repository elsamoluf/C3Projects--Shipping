class ShipmentsController < ApplicationController

  # def fetch_fedex_rates
  #   fedex = FedexClient.new
  #   shipment = JSON.parse(params[:json_data])["shipment"]
  #   rates = fedex.fetch_rates(shipment)
  #
  #   render json: rates
  # end
  #
  # def fetch_usps_rates
  #   usps = UspsClient.new
  #   shipment = JSON.parse(params[:json_data])["shipment"]
  #   rates = usps.fetch_rates(shipment)
  #
  #   render json: rates
  # end

  def rates
    shipment = {
      shipment: {
        origin: {
          country: "US",
          city: "Seattle",
          state: "WA",
          zipcode: "98106"
        },
        destination: {
          country: "US",
          city: "Minneapolis",
          state: "MN",
          zipcode: "55414"
        },
        packages: {
          weight: 2,
          dimensions: [2, 2, 2]
        }
      }
    }

    json_shipment = shipment.to_json

    params[:json_data] = json_shipment

    # raise
    shipment = JSON.parse(params[:json_data])["shipment"]
    fedex_rates = FedexClient.new.fetch_rates(shipment)
    usps_rates = UspsClient.new.fetch_rates(shipment)

    both_rates = fedex_rates + usps_rates


    unless both_rates.empty?
      render json: both_rates, status: :ok
    else
      render json: [], status: :no_content
    end
  end

  # def index
  #   ### WIP
  #   # accept betsy address strings, convert into active shipping location objects
  #   # destination
  #   state = params[:betsy_address][:state]
  #   city = params[:betsy_address][:city]
  #   zip = params[:betsy_address][:zip]
  #   destination = ActiveShipping::Location.new(country: 'US', state: state, city: city, zip: zip)
  #
  #   # origin
  #   merchant_state = params[:merchant_address][:state]
  #   merchant_city = params[:merchant_address][:city]
  #   marchant_zip = params[:merchant_address][:zip]
  #   origin = ActiveShipping::Location.new(country: 'US', state: merchant_state, city: merchant_city, zip: merchant_zip)
  #
  #   # packages
  #   product_weight = params[:product_dimensions][:weight] # 5 lb
  #   product_dimensions = params[:product_dimensions][:dimensions] # [10l, 10w, 10h]
  #   packages = [
  #     ActiveShipping::Package.new(product_weight, product_dimensions, units: :imperial)
  #   ]
  #   ###
  #
  #   # FEDEX
  #   fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
  #
  #   response = fedex.find_rates(origin, destination, packages)
  #   fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  #
  #   # USPS
  #   usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], test: true)
  #   response = usps.find_rates(origin, destination, packages)
  #   usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  #
  #   rates = fedex_rates + usps_rates
  #
  #   unless rates.empty?
  #     render json: rates.as_json, status: :ok
  #   else
  #     render json: [], status: :no_content
  #   end
  # end

end
