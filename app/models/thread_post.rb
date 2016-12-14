class ThreadPost < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_many :messages
end
