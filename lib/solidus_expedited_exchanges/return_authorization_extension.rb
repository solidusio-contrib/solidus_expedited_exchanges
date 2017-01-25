module SolidusExpeditedExchanges
  module ReturnAuthorizationExtension
    def self.included(klass)
      klass.class_eval do
        after_save :generate_expedited_exchange_reimbursements

        # These are called prior to generating expedited exchanges shipments.
        # Should respond to a "call" method that takes the list of return items
        class_attribute :pre_expedited_exchange_hooks
        self.pre_expedited_exchange_hooks = []
      end
    end

    def generate_expedited_exchange_reimbursements
      return unless Spree::Config[:expedited_exchanges]

      items_to_exchange = return_items.select(&:exchange_required?)
      items_to_exchange.each(&:attempt_accept)
      items_to_exchange.select!(&:accepted?)

      return if items_to_exchange.blank?

      pre_expedited_exchange_hooks.each { |h| h.call items_to_exchange }

      reimbursement = Spree::Reimbursement.new(return_items: items_to_exchange, order: order)

      if reimbursement.save
        reimbursement.perform!
      else
        errors.add(:base, reimbursement.errors.full_messages)
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end
  end
end
