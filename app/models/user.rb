class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  has_many :borrowings, class_name: "Stock",
                        foreign_key: "holder",
                        dependent: :restrict_with_exception
  has_many :contributions, class_name: "Stock",
                        foreign_key: "registerer",
                        dependent: :nullify
  has_many :notifications, dependent: :nullify


end
