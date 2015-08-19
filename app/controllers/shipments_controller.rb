require 'active_shipping'

class ShipmentsController < ApplicationController

  def index
    # FEDEX
    fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)

    ### WIP
    # accept betsy address strings, convert into active shipping location objects
    # destination
    state = params[:betsy_address][:state]
    city = params[:betsy_address][:city]
    zip = params[:betsy_address][:zip]

    # origin
    # ???

    # packages
    # ???

    destination = ActiveShipping::Location.new(country: 'US', state: state, city: city, zip: zip)
    # create origin too
    # and packages
    ###

    response = fedex.find_rates(origin, destination, packages)
    fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # USPS
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], test: true)
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # WIP - combine rates arrays?
    rates = fedex_rates + usps_rates

    unless rates.empty?
      render json: rates.as_json, status: :ok
    else
      render json: [], status: :no_content
    end
  end

end
