require 'googleauth'
require 'google/apis/calendar_v3'

class DelegatedGoogleCalendar
  def initialize(config, logger)
    @config = config
    @logger = logger

    if @config['google']['key'].present?
      ENV['GOOGLE_PRIVATE_KEY']  = @config['google']['key']
      ENV['GOOGLE_CLIENT_EMAIL'] = @config['google']['service_account_email']
      ENV['GOOGLE_ACCOUNT_TYPE'] = 'service_account'
    elsif @config['google']['key_file'].present?
      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = @config['google']['key_file']
    end

    @calendar = Google::Apis::CalendarV3::CalendarService.new
    scopes    = [Google::Apis::CalendarV3::AUTH_CALENDAR]
    @authorization = Google::Auth.get_application_default(scopes)

    delegated_email = @config.dig('google', 'delegated_email')
    if delegated_email && !delegated_email.empty? && @authorization.respond_to?(:sub=)
      @authorization.sub = delegated_email
      @logger.info("DelegatedGoogleCalendar: impersonating #{delegated_email}")
    else
      @logger.info("DelegatedGoogleCalendar: using service account identity")
    end
  end

  def self.open(*args, &block)
    instance = new(*args)
    block.call(instance)
  ensure
    instance&.cleanup!
  end

  def auth_as
    @authorization.fetch_access_token!
    @calendar.authorization = @authorization
  end

  def publish_as(who, details)
    auth_as
    event = Google::Apis::CalendarV3::Event.new(**details.deep_symbolize_keys)
    ret   = @calendar.insert_event(who, event, send_notifications: true)
    ret.to_h
  end

  def cleanup!
    ENV.delete('GOOGLE_PRIVATE_KEY')
    ENV.delete('GOOGLE_CLIENT_EMAIL')
    ENV.delete('GOOGLE_ACCOUNT_TYPE')
    ENV.delete('GOOGLE_APPLICATION_CREDENTIALS')
  end
end
