class NotificationsMailer < ActionMailer::Base
  default :from => "no-reply@bitesite.ca"
  
  def contact_confirmation(first_name, last_name, customer_email, message)
    
    attachments.inline['emailheader.png'] = File.read(Rails.root.join('app/assets/images/emailheader.png'))
    
    @first_name, @last_name, @message = first_name, last_name, message
    
    mail(:to => customer_email,
         :from => "no-reply@bitesite.ca",
         :subject => "Thanks for contacting BiteSite.ca!")
  end
end
