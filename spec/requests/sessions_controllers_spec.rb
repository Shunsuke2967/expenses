require 'rails_helper'

RSpec.describe "SessionsControllers", type: :request do
  describe 'GET #index' do
    before{ get sessions_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end

    context 'ログインしている場合' do
      before{
        login create(:user)
        get sessions_path
      }

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST #creaet' do
    let(:user){ create(:user, password: 'password', password_confirmation: 'password') }
    subject{ post sessions_path, params: params }
    let(:params) do
      {
        session: {
          email: user.email,
          password: 'password'
        }
      }
    end

    it 'ログインできること' do
      subject
      expect(session[:user_id]).to eq user.id
    end

    it 'メッセージが表示されること' do
      subject
      expect(flash[:notice]).to eq 'ログインしました'
    end

    context '認証エラーになった場合' do

      let(:params) do
        {
          session: {
            email: nil,
            password: nil
          }
        }
      end

      it 'ログインできないこと' do
        subject
        expect(session[:user_id]).not_to eq user.id
      end

      it 'エラーメッセージが表示されていること' do
        subject
        expect(flash[:danger]).to eq 'ログインできませんでした'
      end
    end
  end


  describe 'GET #demo' do
    subject{ get demo_sessions_path }

    it 'ログインできること' do
      subject
      expect(session[:user_id]).to eq User.last.id
    end

    it 'session[:demo]がセットされていること' do
      subject
      expect(session[:demo]).to eq true
    end

    context 'デモデータの作成に失敗した場合' do
      before{ allow(User).to receive(:demo_data_create).and_return(nil) }

      it 'ログインされないこと' do
        subject 
        expect(session[:user_id]).to eq nil
      end

      it 'エラーメッセージが表示されていること' do
        subject
        expect(flash[:danger]).to eq 'エラーが発生しデモ画面に入れませんでした'
      end
    end
  end
end
