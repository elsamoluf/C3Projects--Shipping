require 'active_shipping'

class ShipmentsController < ApplicationController

def index
  fedex = ActiveShipping::FedEx.new(login: ENV['ACTIVESHIPPING_FEDEX_LOGIN'], password: ENV['ACTIVESHIPPING_FEDEX_PASSWORD'], key: ENV['ACTIVESHIPPING_FEDEX_KEY'], account: ENV['ACTIVESHIPPING_FEDEX_ACCOUNT'], meter: ENV['ACTIVESHIPPING_FEDEX_METER'], test: true)
  response = fedex.find_rates(origin, destination, packages)
  fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  
  unless fedex_rates.empty?
    render json: fedex_rates.as_json, status: :ok
  else
    render json: [], status: :no_content
  end
end

end
