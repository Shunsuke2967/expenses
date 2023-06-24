require 'rails_helper'

RSpec.describe "ChartsControllers", type: :request do
  let(:user){ create(:user) }
  before{ login(user) }
  describe 'GET #index' do
    before{ get charts_path }
    it 'HTTP200ステータスが表示されること' do
      expect(response).to have_http_status(200)
    end

    context '支出がある場合' do
      before do
        expense = user.expenses.last
        create(:day, icon: :rent, money: 99999, spending: true, expense: expense)
        get charts_path
      end

      it '支払いがグラフに反映されていること' do
        expect(response.body).to include '99999'
      end
    end
  end
end
