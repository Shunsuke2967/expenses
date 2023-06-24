require 'rails_helper'

RSpec.describe "ExpensesControllers", type: :request do
  let!(:expense){ create(:expense, user: user) }
  let(:user){ create(:user) }
  before { login user }

  describe "GET #index" do
    before { 
      create(:day, expense: expense)
      get expenses_path
    }

    it 'HTTPステータスコード200を返す' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    before { get new_expense_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #edit_salary" do
    before { get edit_salary_expenses_path }

    it 'HTTPステータスコード200を返す' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #salary_list' do
    before { get salary_list_expenses_path }
    
    it 'HTTPステータスコード200を返す' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH update_salary' do
    subject{ patch update_salary_expenses_path, params: params }
    let(:params) do
      {
        expense: {
          salary: 99999
        }
      }
    end

    it '給料設定が更新されていること' do
      expect{ subject }.to change{ expense.reload.salary }.to(99999)
    end
  end

  describe "POST #create" do
    subject { post expenses_path, params: params }
    let(:params) do
      {
        expense: {
          year: 2023,
          month: 1,
          salary: 10000,
          salary_2: 5000,
          salary_3: 5000,
          salary_4: 5000
        }
      }
    end
    it "Expenseが作成されること" do
      expect{ subject }.to change(Expense, :count).by(1)
    end
  end
end
