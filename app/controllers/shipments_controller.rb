require 'active_shipping'

class ShipmentsController < ApplicationController

  def index
    ### WIP
    # accept betsy address strings, convert into active shipping location objects
    # destination
    state = params[:betsy_address][:state]
    city = params[:betsy_address][:city]
    zip = params[:betsy_address][:zip]
    destination = ActiveShipping::Location.new(country: 'US', state: state, city: city, zip: zip)

    # origin
    merchant_state = params[:merchant_address][:state]
    merchant_city = params[:merchant_address][:city]
    marchant_zip = params[:merchant_address][:zip]
    origin = ActiveShipping::Location.new(country: 'US', state: merchant_state, city: merchant_city, zip: merchant_zip)

    # packages
    product_weight = params[:product_dimensions][:weight] # 5 lb
    product_dimensions = params[:product_dimensions][:dimensions] # [10l, 10w, 10h]
    packages = [
      ActiveShipping::Package.new(product_weight, product_dimensions, units: :imperial)
    ]
    ###

    # FEDEX
    fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)

    response = fedex.find_rates(origin, destination, packages)
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # USPS
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], test: true)
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    rates = fedex_rates + usps_rates

    unless rates.empty?
      render json: rates.as_json, status: :ok
    else
      render json: [], status: :no_content
    end
  end

end
