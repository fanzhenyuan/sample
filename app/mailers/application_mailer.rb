class ApplicationMailer < ActionMailer::Base
  #默认的发件人地址
  default from: "noreply@example.com"
  layout 'mailer'
end
