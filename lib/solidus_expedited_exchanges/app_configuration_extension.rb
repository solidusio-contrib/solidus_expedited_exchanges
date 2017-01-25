module SolidusExpeditedExchanges
  module AppConfigurationExtension
    def self.included(klass)
      klass.class_eval do
        # @!attribute [rw] create_rma_for_unreturned_exchange
        #   @return [Boolean] allows rma to be created for items after unreturned exchange charge has been made (default: +false+)
        preference :create_rma_for_unreturned_exchange, :boolean, default: false

        # @!attribute [rw] expedited_exchanges
        #   Kicks off an exchange shipment upon return authorization save.
        #   charge customer if they do not return items within timely manner.
        #   @note this requires payment profiles to be supported on your gateway of
        #     choice as well as a delayed job handler to be configured with
        #     activejob.
        #   @return [Boolean] Use expidited exchanges (default: +false+)
        preference :expedited_exchanges, :boolean, default: false

        # @!attribute [rw] expedited_exchanges_days_window
        #   @return [Integer] Number of days the customer has to return their item
        #     after the expedited exchange is shipped in order to avoid being
        #     charged (default: +14+)
        preference :expedited_exchanges_days_window, :integer, default: 14
      end
    end
  end
end
