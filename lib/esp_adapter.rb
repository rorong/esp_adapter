# frozen_string_literal: true

require_relative "esp_adapter/version"

module EspAdapter
  class Error < StandardError; end
  # Your code goes here...

  def self.description
    puts "Test EspAdapter gem"
  end
end
