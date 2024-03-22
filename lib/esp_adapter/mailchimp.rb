# frozen_string_literal: true

require "MailchimpMarketing"
require_relative "base"

module EspAdapter
  # class for handling MailChimp
  class Mailchimp < Base
    attr_reader :mailchimp_adapter

    def initialize(api_key = "")
      super
      initialize_mailchimp_adapter(api_key)
    end

    def lists
      handle_errors do
        mailchimp_adapter.lists.get_all_lists["lists"]
      end
    end

    def list_metrics(list_id)
      handle_errors do
        members = mailchimp_adapter.lists.get_list_members_info(list_id)["members"]
        members_count = members.count
        member_details = get_members_data(members)

        { subscriber_count: members_count, member_details: member_details }
      end
    end

    private

    def get_members_data(members)
      member_details = []
      members.each do |member|
        member_hs = member["stats"]
        member_hs["email"] = member["email_address"]

        member_details << member_hs
      end

      member_details
    end

    def handle_errors
      yield
    rescue Resolv::ResolvError
      { error: "Requested API could not be fetched" }
    rescue MailchimpMarketing::ApiError => e
      if e.message.include?("Resource Not Found")
        { error: "Requested newsletter list is invalid" }
      elsif e.message.include?("401")
        { error: "Invalid API key passed" }
      else
        { error: "An error has occurred while performing the action" }
      end
    end

    def initialize_mailchimp_adapter(api_key)
      @mailchimp_adapter = MailchimpMarketing::Client.new
      @mailchimp_adapter.set_config({ api_key: api_key, server: "us18" })
    end
  end
end
