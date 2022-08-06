class Setting < ApplicationRecord
  belongs_to :user
  has_many :contents

  enum setting_type: {
    home: 1,
    date: 2,
    bank: 3,
    transition: 4
  }
end
