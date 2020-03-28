class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :validatable
end
