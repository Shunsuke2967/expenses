require 'rails_helper'

RSpec.describe "TemplatesControllers", type: :request do
  let!(:expense){ create(:expense, user: user) }
  let(:user){ create(:user) }
  before{ login user }
  describe 'GET #new' do
    before{ get new_template_path }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #edit' do
    let!(:template){ create(:template, user: user) }
    before{ get edit_template_path(template) }

    it 'HTTPステータスコード200を返すこと' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    subject{ post templates_path, params: params }
    let(:params) do
      {
        template: {
          icon: "rent",
          money: 12345,
          spending: true,
          memo: 'テスト用メモ'
        }
      }
    end

    it 'Templateが作成されること' do
      expect{ subject }.to change(Template, :count).by(1)
    end

    context 'パラメーターが不正な場合' do
      let(:params) do
        {
          template: {
            icon: "rent",
            money: nil,
            spending: true,
            memo: 'テスト用メモ'
          }
        }
      end

      it 'Templateが作成されないこと' do
        expect{ subject }.not_to change(Template, :count)
      end

      it 'エラーメッセージが表示されていること' do
        subject
        expect(response.body).to include "#{Template.human_attribute_name(:money)}#{I18n.t('errors.messages.blank')}"
      end
    end
  end

  describe 'PATCH #update' do
    let!(:template){ create(:template, memo: 'テスト用テンプレートメモ', user: user) }
    subject{ patch template_path(template), params: params }

    let(:params) do
      {
        template: {
          icon: 'rent',
          money: 12345,
          spending: true,
          memo: '更新後の値'
        }
      }
    end

    it 'Templateの値が更新されていること' do
      expect{ subject }.to change{ template.reload.memo }.to('更新後の値')
    end

    context 'パラメーターが不正の場合' do
      let(:params) do
        {
          template: {
            icon: 'rent',
            money: nil,
            spending: true,
            memo: '更新後の値'
          }
        }
      end

      it 'Templateの値が更新されていないこと' do
        expect{ subject }.not_to change{ template.reload.memo }.from('テスト用テンプレートメモ')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:template){ create(:template, memo: 'テスト用テンプレートメモ', user: user) }
    subject{ delete template_path(template) }

    it 'Templateが削除されていること' do
      expect{ subject }.to change(Template, :count).by(-1)
    end
  end

  describe 'GET #day_select' do
    let(:template){ create(:template, memo: 'テンプレートメモ1', user: user) }
    let(:template_1){ create(:template, memo: 'テンプレートメモ2', user: user) }
    let(:template_2){ create(:template, memo: 'テンプレートメモ3', user: user) }
    let(:params){ { ids: [template.id, template_1.id, template_2.id] } }
    before{ get day_select_templates_path, params: params }

    it 'チェックしたテンプレートが表示されていること' do
      expect(response.body).to include('テンプレートメモ1') | include('テンプレートメモ2') | include('テンプレートメモ3')
    end

    context 'idが送られなかった場合' do
      let(:params){ { ids: {} } }

      it 'root_pathにリダイレクトされること' do
        expect(response).to redirect_to root_path
      end

      it 'エラーメッセージが表示されていること' do
        expect(flash[:danger]).to eq '一つ以上選択してください'
      end
    end
  end

  describe 'POST #days_create' do
    let(:template){ create(:template, memo: 'テンプレートメモ1', user: user) }
    let(:template_1){ create(:template, memo: 'テンプレートメモ2', user: user) }
    let(:template_2){ create(:template, memo: 'テンプレートメモ3', user: user) }

    let(:params){
      { date_at: { 
        template.id => "1", 
        template_1.id => "10",
        template_2.id => "20"
      } }
    }
    subject{ post days_create_templates_path, params: params }

    it 'Dayが作成されていること' do
      expect{ subject }.to change{ Day.where(memo: 'テンプレートメモ1').count }.by(1)
        .and(change{ Day.where(memo: 'テンプレートメモ2').count }.by(1))
        .and(change{ Day.where(memo: 'テンプレートメモ3').count }.by(1))
    end

    context '選択されなかった場合' do
      let(:params){
        { data_at: {} }
      }

      it 'Dayが作成されていないこと' do
        expect{ subject }.not_to change(Day, :count)
      end

      it 'エラーメッセージが表示されていること' do
        subject
        expect(flash[:danger]).to eq '対象が見つかりません'
      end
    end

    context '追加処理中にエラーが発生した場合' do
      # 処理中にエラーになる状況が見つからなかったためモック
      before{
        allow_any_instance_of(Expense).to receive(:days_create).and_return(false)
      }

      it 'エラーメッセージが表示されること' do
        subject
        expect(flash[:danger]).to eq '追加時にエラーが発生しました'
      end
    end
  end
end
