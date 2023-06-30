require 'twilio-ruby'

module Twilio
    class SmsService
          def initialize(to:, pin:)
              @to = to
              @pin = pin
          end
  
          def send_otp
              account_sid = 'ACb1286d25f91ec950d7f7364e7f29b493'
              auth_token = '5378d4e37424e3ab2e66536d90fd87df'
              from = '+917019824855'
              @client = Twilio::REST::Client.new(account_sid, auth_token)              
              verification = @client.verify
                                      .v2
                                      .services('VA8839b0c3a8e6f1406855d6280eeec65b')
                                      .verifications
                                      .create(to: @to, channel: 'sms')
          end
  
          def verify_otp
               account_sid = 'ACb1286d25f91ec950d7f7364e7f29b493'
               auth_token = '5378d4e37424e3ab2e66536d90fd87df'
              @client = Twilio::REST::Client.new(account_sid, auth_token)
              verification_check = @client.verify
                              .v2
                              .services('VA8839b0c3a8e6f1406855d6280eeec65b')
                              .verification_checks
                              .create(to: @to, code: @pin)
              return  {status: verification_check.status}
          end
      end
      
  end