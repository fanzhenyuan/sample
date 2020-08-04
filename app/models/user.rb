class User < ApplicationRecord
  #删除用户,微博也delete
  has_many :microposts, dependent: :destroy 
  #可存取的属性
  attr_accessor :remember_token, :activation_token, :reset_token
  #before_save { self.email = email.downcase}
  #before_save { email.downcase! }
  before_save :downcase_email
  before_create :create_activation_digest
  
  validates :name, presence: true, length: { maximum: 50 }
  
  REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: REGEX }, 
                    #uniqueness: true
                    #uniqueness: { case_sensitive: false}
                    uniqueness: true
  #rails generate migration add_activation_to_users
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
  
  #def authenticated?(remember_token)
  def authenticated?(attribute, token)
    #return false if remember_digest.nil?
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    #self.remember_digest
    BCrypt::Password.new(digest).is_password?(token)
  end 
  
  #撤销 user.remember 方法的操作
  def forget
    update_attribute(:remember_digest, nil)
  end 
  
  #把处理用户的代码从控制器中移出， 放入模型
  def activate
    #update_attribute(:activated, true)
    #self.update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end 
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end 
  
  #重设再要以及时间
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end 
  #发生重设密码
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end 
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago 
  end
  #初步实现微博动态流
  def feed
    Micropost.where("user_id=?", id)
  end 
  # 创建令牌和摘要
  private
  
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end 
end
