require 'rails_helper'

RSpec.describe "BudgetsController", type: :request do
  let(:user){ create(:user) }
  before { login user }
  describe "GET #new" do
    before { get new_budget_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #edit" do
    let!(:budget){ create(:budget, rent: 12345, expense: Expense.find(session[:expense_id])) }
    before { get edit_budget_path(budget) }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    subject { post budgets_path, params: params }
    let(:params) do
      {
        budget: {
          rent: 1000,
          cost_of_living: 1000,
          entertainment: 1000,
          food_expenses: 1000,
          car_cost: 1000,
          insurance: 1000,
          other: 1000
        }
      }
    end
    it "Budgetが作成されること" do
      expect{ subject }.to change(Budget, :count).by(1)
    end

    context 'パラメーターが不正の場合' do
      # 家賃のパラメーターを空にする
      let(:params) do
        {
          budget: {
            rent: nil,
            cost_of_living: 1000,
            entertainment: 1000,
            food_expenses: 1000,
            car_cost: 1000,
            insurance: 1000,
            other: 1000
          }
        }
      end
      it 'Budgetが作成されないこと' do
        expect{ subject }.not_to change(Budget, :count)
      end

      it 'エラーが表示されること' do
        subject
        expect(flash[:alert]).to include "#{Budget.human_attribute_name(:rent)}#{I18n.t('errors.messages.blank')}"
      end
    end
  end

  describe "PATCH #update" do
    let!(:budget){ create(:budget, rent: 12345, expense: Expense.last) }
    subject { patch budget_path(budget), params: params }
    let(:params) do
      {
        budget: {
            rent: 11111
        }
      }
    end

    it '値が更新されていること' do
      expect{ subject }.to change { budget.reload.rent }.to eq 11111
    end

    context '不正な値の場合' do
      let(:params) do
        {
          budget: {
              rent: nil
          }
        }
      end

      it '値が変更されていないこと' do
        expect{ subject }.not_to change{ budget.reload.rent }.from(12345)
      end
    end
  end
end
