class User < ApplicationRecord
  has_many :months,dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :settings
  has_many :contents
  has_secure_password

  validates :name, presence: true
  validates :email,presence: true,uniqueness: true
  validates :password, confirmation: true


  # settingがすべてない場合は作成する
  # ある場合は作成しない
  # settingsを返す
  # コンテンツはデフォルトの値がある
  def setting_prepare
    types = Setting.setting_types.dup
    self.settings.each do |setting|
      types.delete(setting.setting_type)
    end
    types.each do |type, index|
      self.settings.create(setting_type: type)
    end
    # 初期値を設定
    # 削除は不可
    self.set_default_content

    return User.includes(:contents).order("contents.sort_order ASC").find(self.id).settings
  end

  def set_default_content
    contens = self.contents

    if contens.current_income_and_expenditure.blank?
      contents.create(setting_id: self.settings.home.first.id, content_type: "current_income_and_expenditure", sort_order: 0, fix: false)
    end

    if contens.list_of_details.blank?
      contents.create(setting_id: self.settings.home.first.id, content_type: "list_of_details", sort_order: 0, fix: false)
    end

    if contens.current_salary.blank?
      contents.create(setting_id: self.settings.bank.first.id, content_type: "current_salary", sort_order: 0, fix: false)
    end
  end
end
