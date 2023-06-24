require 'rails_helper'

RSpec.describe "ChartsControllers", type: :request do
  let(:user){ create(:user) }
  before{ login(user) }
  describe 'GET #index' do
    before{ get charts_path }
    it 'HTTP200ステータスが表示されること' do
      expect(response).to have_http_status(200)
    end
  end
end
