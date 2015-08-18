require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do
  describe "GET #index" do
    it "is successful" do
      get :index
      expect(response.response_code).to eq 200
    end

    it "returns json" do
      get :index
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end

end
