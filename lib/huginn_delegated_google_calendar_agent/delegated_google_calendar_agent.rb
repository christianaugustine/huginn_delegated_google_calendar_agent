module Agents
  class DelegatedGoogleCalendarPublishAgent < Agents::GoogleCalendarPublishAgent
    # override only what you need
    def default_options
      super.tap do |opts|
        opts['google']['delegated_email'] ||= ''
      end
    end

    # if you changed receive, define it here;
    # otherwise you can even keep using super
  end
end
