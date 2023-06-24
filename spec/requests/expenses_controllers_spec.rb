require 'rails_helper'

RSpec.describe "ExpensesControllers", type: :request do
  let!(:expense){ create(:expense, user: user) }
  let(:user){ create(:user) }
  before { login user }

  describe "GET #index" do
    before { 
      create(:day, expense: expense, memo: 'テスト用明細メモ')
      get expenses_path
    }

    it 'HTTPステータスコード200を返す' do
      expect(response).to have_http_status(200)
    end

    it '明細の一覧が表示されていること' do
      expect(response.body).to include '明細一覧'
      expect(response.body).to include 'テスト用明細メモ'
    end

    it '口座残高が表示されていること' do
      expect(response.body).to include '口座残高'
    end

    it '総合収支が表示されてること' do
      expect(response.body).to include '総合収支'
    end
  end

  describe "GET #new" do
    before { get new_expense_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end

    it '期待する画面が表示されていること' do
      expect(response.body).to include 'id="expense_salary"'
    end
  end

  describe "GET #edit_salary" do
    before { 
      Expense.last.update(salary: 99999)
      get edit_salary_expenses_path
    }

    it '期待する画面が表示されていること' do
      expect(response.body).to include '99999'
    end

    it '期待する画面が表示されていること' do
      expect(response.body).to include '収入１※入力必須'
    end
  end

  describe 'GET #salary_list' do
    before {
      Expense.last.update(salary: 99999)
      get salary_list_expenses_path 
    }
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
