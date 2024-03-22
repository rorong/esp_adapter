# frozen_string_literal: true

RSpec.describe EspAdapter do
  it "has a version number" do
    expect(EspAdapter::VERSION).not_to be nil
  end

  describe "#lists" do
    let!(:lists_data) do
      { "lists": [{ "id": "111zzz", "name": "testuser" }] }.with_indifferent_access
    end

    before do
      allow_any_instance_of(MailchimpMarketing::Client).to receive_message_chain(:lists, :get_all_lists).and_return(lists_data)
    end

    it "returns lists data" do
      adapter = EspAdapter::Mailchimp.new
      expect(adapter.lists).to eq lists_data["lists"]
    end
  end

  describe "#list_metrics" do
    let!(:list_data) do
      {
        "members": [
          {
            "id": "1111111111zzzzzzzzzz",
            "email_address": "user@example.com",
            "stats": { "avg_open_rate": 0, "avg_click_rate": 0 }
          }
        ]
      }.with_indifferent_access
    end

    before do
      allow_any_instance_of(MailchimpMarketing::Client).to receive_message_chain(:lists, :get_list_members_info).and_return(list_data)
    end

    it "returns the requested list data" do
      adapter = EspAdapter::Mailchimp.new
      expected_result = {
        member_details: [list_data["members"][0]["stats"]],
        subscriber_count: 1
      }
      expect(adapter.list_metrics("1111")).to eq expected_result
    end
  end
end
