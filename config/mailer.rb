ActionMailer::Base.smtp_settings = {
  address: "smtp.mandrillapp.com",
  port: 587,
  enable_starttls_auto: true,
  user_name: 'care@zuplr.com',
  password: '0Hb1j5UKhJtKLS9k3fZN6w',
  authentication: 'plain'
}

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default charset: "utf-8"