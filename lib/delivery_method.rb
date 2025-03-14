# frozen_string_literal: true
require 'railtie'
require 'zohozeptomail_mailer'

module ZohozeptomailRails
  class Mailer
    def initialize(config)
      # No config yet
    end

    # Sends the email and returns result
    def deliver(msg)
      ms_msg = RailsMsgToMsMsg.msg_to_ms_msg(msg)
      ms_msg.send
    end

    def settings
        # Define the settings method or use a custom configuration object
        @settings ||= { return_response: true }  # Example settings
    end

    def deliver!(msg)
       result = deliver(msg)
       # Ensure result is not nil
       if result.nil? || result.status < 200 || result.status > 204
           puts result
       end
       result
    end
    private
  end
end