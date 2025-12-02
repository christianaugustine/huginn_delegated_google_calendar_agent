require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::DelegatedGoogleCalendarAgent do
  before(:each) do
    @valid_options = Agents::DelegatedGoogleCalendarAgent.new.default_options
    @checker = Agents::DelegatedGoogleCalendarAgent.new(:name => "DelegatedGoogleCalendarAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
