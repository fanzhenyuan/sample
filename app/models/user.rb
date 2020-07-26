class User < ApplicationRecord
  #可存取的属性
  attr_accessor :remember_token
  #before_save { self.email = email.downcase}
  before_save { email.downcase! }
  
  validates :name, presence: true, length: { maximum: 50 }
  
  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: REGEX }, 
                    #uniqueness: true
                    #uniqueness: { case_sensitive: false}
                    uniqueness: true
  
  #密码为 nil 时能通过存在性验证，可是会被 has_secure_password 方法的验证捕获
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  
  
  #返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  #返回随机令牌 string
  def User.new_token
    SecureRandom.urlsafe_base64
  end 
  
  def remember
    #使用 self 的目的是确保把值赋 给用户的 remember_token 属性
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    #self.remember_digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end 
  
  #撤销 user.remember 方法的操作
  def forget
    update_attribute(:remember_digest, nil)
  end 
end
