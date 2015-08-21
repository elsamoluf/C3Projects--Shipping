class ShipmentsController < ApplicationController

  def rates
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

end
