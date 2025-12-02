module Agents
  class DelegatedGoogleCalendarAgent < Agents::GoogleCalendarPublishAgent
    # Or < Agent if you prefer – but we’ll define working? either way.

    def default_options
      super.tap do |opts|
        opts['google'] ||= {}
        opts['google']['delegated_email'] ||= ''
      end
    end

    # 🔴 THIS IS THE IMPORTANT PART 🔴
    # Override working? so we don't hit Agent#working?
    def working?
      event_created_within?(options['expected_update_period_in_days']) &&
        most_recent_event &&
        most_recent_event.payload['success'] == true &&
        !recent_error_logs?
    end
  end
end
