require 'twilio-ruby'

module Twilio
    class SmsService
          def initialize(to:, pin:)
              @to = to
              @pin = pin
          end
  
          def send_otp
              account_sid = ENV['account_sid']
              auth_token = ENV['auth_token']
              @client = Twilio::REST::Client.new(account_sid, auth_token)              
              verification = @client.verify
                                      .v2
                                      .services(ENV['services'])
                                      .verifications
                                      .create(to: @to, channel: 'sms')
          end
  
          def verify_otp
            account_sid = ENV['account_sid']
            auth_token = ENV['auth_token']
               @client = Twilio::REST::Client.new(account_sid, auth_token)
               verification_check = @client.verify
                              .v2
                              .services(ENV['services'])
                              .verification_checks
                              .create(to: @to, code: @pin)
              return  {status: verification_check.status}
          end
      end
    end
    