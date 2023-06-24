require 'rails_helper'

RSpec.describe "TransitionsControllers", type: :request do
  let(:user){ create(:user) }
  before{ login(user) }
  describe 'GET #index' do
    before{ get transitions_path }
    it 'HTTP200ステータスが表示されること' do
      expect(response).to have_http_status(200)
    end

    it '口座残高推移が表示されていること' do
      expect(response.body).to include '口座残高推移'
    end

    it '直近12ヶ月収支推移が表示されていること' do
      expect(response.body).to include '直近12ヶ月収支推移'
    end
  end
end
