ActionMailer::Base.smtp_settings = {  
  address:               "smtp.gmail.com",  
  port:                  587,  
  domain:                "gmail.com",  
  user_name:             "sharebox.test.app",  
  password:              "123456shareboxtestapp",  
  authentication:        "plain",  
  enable_starttls_auto:  true  
}  