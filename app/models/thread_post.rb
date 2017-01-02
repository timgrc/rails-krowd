class ThreadPost < ApplicationRecord
  belongs_to :group
  # belongs_to :user
  has_many :messages
end
