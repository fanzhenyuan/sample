class User < ApplicationRecord
  #before_save { self.email = email.downcase}
  before_save { email.downcase! }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: REGEX }, 
                    #uniqueness: true
                    #uniqueness: { case_sensitive: false}
                    uniqueness: true
  
  #只会验证有没有密码 空string可以
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }  
  #返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end 
end
