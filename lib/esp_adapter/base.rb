# frozen_string_literal: true

module EspAdapter
  # Base class for handling ESPs
  class Base
    def initialize(api_key)
      @api_key = api_key
    end

    def lists
      handle_errors do
        # logic to fetch lists
      end
    end

    def list_metrics(list_id)
      handle_errors do
        # logic to get metrics
      end
    end

    private

    def handle_errors
      yield
    rescue *ExpectedErrors => e
      # log errror
      raise CustomError, "An error has occurred while performing action: #{e.message}"
    end
  end
end
