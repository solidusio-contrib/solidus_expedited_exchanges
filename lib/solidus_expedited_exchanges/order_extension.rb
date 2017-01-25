module SolidusExpeditedExchanges
  module OrderExtension
    def self.prepended(klass)
      klass.class_eval do
        scope :unreturned_exchange, -> { joins(:shipments).where('spree_orders.created_at > spree_shipments.created_at') }
      end
    end

    def create_proposed_shipments
      return shipments if unreturned_exchange?

      super()
    end

    def unreturned_exchange?
      # created_at - 1 is a hack to ensure that this doesn't blow up on MySQL,
      # records loaded from the DB on MySQL will have a precision of 1 second,
      # but records in memory may still have miliseconds on them, causing this
      # to be true where it shouldn't be.
      #
      # FIXME: find a better way to determine if an order is an unreturned
      # exchange
      shipment = shipments.first
      shipment.present? ? (shipment.created_at < created_at - 1) : false
    end
  end
end
