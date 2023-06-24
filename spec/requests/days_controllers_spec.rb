require 'rails_helper'

RSpec.describe "DaysControllers", type: :request do
  let!(:expense){ create(:expense, user: user) }
  let(:user){ create(:user) }
  before { login user }
  describe "GET #new" do
    before { get new_day_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #edit" do
    let!(:day){ create(:day, expense: expense) }
    before { get edit_day_path(day) }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    subject { post days_path, params: params }
    let(:params) do
      {
        day: {
          spending: true,
          money: 12345,
          day_at: Time.current,
          memo: "テスト用メモ",
          icon: 'rent'
        }
      }
    end
    it "Dayが作成されること" do
      expect{ subject }.to change(Day, :count).by(1)
    end

    context 'パラメーターが不正の場合' do
      # 支払額を空にする
      let(:params) do
        {
          day: {
            spending: true,
            money: nil ,
            day_at: Time.current,
            memo: "テスト用メモ",
            icon: 'rent'
          }
        }
      end
      it 'Dayが作成されないこと' do
        expect{ subject }.not_to change(Day, :count)
      end

      it 'エラーが表示されること' do
        subject
        expect(response.body).to include "#{Day.human_attribute_name(:money)}#{I18n.t('errors.messages.blank')}"
      end
    end
  end

  describe "PATCH #update" do
    let!(:day){ create(:day, money: 12345, expense: expense) }
    subject { patch day_path(day), params: params }
    let(:params) do
      {
        day: {
          money: 99999
        }
      }
    end

    it '値が更新されていること' do
      expect{ subject }.to change { day.reload.money }.to eq 99999
    end

    context '不正な値の場合' do
      let(:params) do
        {
          day: {
            money: nil
          }
        }
      end

      it '値が変更されていないこと' do
        expect{ subject }.not_to change{ day.reload.money }.from(12345)
      end
    end
  end
end
