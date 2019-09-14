require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    # 200レスポンスを返すこと
    it "return a 200 responds" do
      get :index
      expect(response).to have_http_status "200"
    end
  end
end
