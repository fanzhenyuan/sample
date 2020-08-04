class Micropost < ApplicationRecord
  belongs_to :user
  #把上传的文件与模型关联起来
  has_one_attached :image
  #排序
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: {in: %W[image/git image/png image/jepg],
                                   message: "must be valid image"},
                    size: {less_than: 5.megabytes,
                           message: "must be less than 5MB"}  
  def display_image
    image.variant(resize_to_limit: [500, 500]) 
  end                         
     
end
