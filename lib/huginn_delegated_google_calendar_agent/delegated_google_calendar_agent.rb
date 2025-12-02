module Agents
  class DelegatedGoogleCalendarAgent < Agent
    cannot_be_scheduled!
    no_bulk_receive!

    def default_options
      {
        'expected_update_period_in_days' => "10",
        'calendar_id' => 'you@example.com',
        'google' => {
          'key_file' => '/path/to/private.key',
          'key' => '-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n',
          'service_account_email' => '',
          'delegated_email' => ''          # 👈 NEW
        }
      }
    end

    def validate_options
      errors.add(:base, "expected_update_period_in_days is required") unless options['expected_update_period_in_days'].present?
    end

    def receive(incoming_events)
      require 'delegated_google_calendar'

      incoming_events.each do |event|
        DelegatedGoogleCalendar.open(interpolate_options(options, event), Rails.logger) do |calendar|
          cal_message = event.payload["message"]
          # same dateTime → date_time fixups as before...

          calendar_event = calendar.publish_as(
            interpolated(event)['calendar_id'],
            cal_message
          )

          create_event payload: {
            'success' => true,
            'published_calendar_event' => calendar_event,
            'agent_id' => event.agent_id,
            'event_id' => event.id
          }
        end
      end
    end
  end
end
