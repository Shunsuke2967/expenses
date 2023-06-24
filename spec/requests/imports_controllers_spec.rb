require 'rails_helper'

RSpec.describe "ImportsControllers", type: :request do
  before{ login create(:user) }
  describe "GET #index" do
    before { get imports_path }
    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it '期待する画面が表示されていること' do
      expect(response.body).to include '一括入力'
    end
  end
end
