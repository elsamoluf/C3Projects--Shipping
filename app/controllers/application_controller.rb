require 'active_shipping'
require 'shipping_client'
require 'fedex_client'
require 'usps_client'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
