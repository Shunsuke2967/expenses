require 'rails_helper'

RSpec.describe 'UsersControllers', type: :request do
  describe 'GET #new' do
    before { get new_user_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #terms' do
    before { get terms_users_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    subject { post users_path, params: }
    let(:params) do
      {
        user: {
          name: 'テスト用ユーザー',
          email: 'test@email.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    it 'ユーザーが作成されていること' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'ログインされていること' do
      subject
      expect(session[:user_id].present?).to eq true
    end

    context 'パラメーターが不正な場合' do
      let(:params) do
        {
          user: {
            name: nil,
            email: 'test@email.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end
      subject { post users_path, params:, headers: { 'Accept' => 'application/js' } }

      it 'ユーザーが作成されていないこと' do
        expect { subject }.not_to change(User, :count)
      end

      it 'flashメッセージが格納されること' do
        subject
        expect(flash[:alert]).to include '名前を入力してください'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    before { login user }
    subject { delete user_path(user) }

    it 'ユーザーがログアウトされていること' do
      expect { subject }.to change { session[:user_id] }.from(user.id).to(nil)
    end
  end
end
