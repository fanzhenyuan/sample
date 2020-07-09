module UsersHelper
  def gravatar_for(user, size: 80)
    #用户的电子邮件地址构成头像的 URL 地址
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) 
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
