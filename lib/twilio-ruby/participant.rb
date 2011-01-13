module Twilio
  class Participant < InstanceResource

    def mute
      update :muted => 'true'
    end

    def unmute
      update :muted => 'false'
    end

    alias :kick :delete

  end
end
