require 'rails_helper'

RSpec.describe 'ImportsControllers', type: :request do
  before { login create(:user) }
  describe 'GET #index' do
    before { get imports_path }
    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end
end
