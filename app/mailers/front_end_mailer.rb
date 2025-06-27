class FrontEndMailer < ApplicationMailer

    include ApplicationHelper  # This enables me to use mydate in the subject line
    helper :application  # This enables me to use mydate in the email template (party_thanks.html.erb)

    def email_to_stores(emails, aliance_name)
        @emails = emails
        @aliance_names = aliance_name
        mail(to: emails, subject: "Alianza activada: #{aliance_name}")
    end

    def send_coupon(email, coupon_id)
        @coupon = Coupon.find(coupon_id)
        mail(to: email, subject: "Cupón recibido!")
    end

end
