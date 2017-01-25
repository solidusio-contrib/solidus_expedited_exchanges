module SolidusExpeditedExchanges
  module AppConfigurationExtension
    def self.included(klass)
      klass.class_eval do
        # @!attribute [rw] create_rma_for_unreturned_exchange
        #   @return [Boolean] allows rma to be created for items after unreturned exchange charge has been made (default: +false+)
        preference :create_rma_for_unreturned_exchange, :boolean, default: false
      end
    end
  end
end
