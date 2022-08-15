class User < ApplicationRecord
  has_many :months,dependent: :destroy
  has_many :templates, dependent: :destroy
  has_many :settings
  has_many :contents
  has_secure_password

  validates :name, presence: true
  validates :email,presence: true,uniqueness: true
  validates :password, confirmation: true
end
