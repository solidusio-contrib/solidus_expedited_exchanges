# frozen_string_literal: true

module SolidusExpeditedExchanges
  class OrderCapturing
    # Allows your store to void unused payments and release auths
    class_attribute :void_unused_payments
    self.void_unused_payments = false

    def initialize(order)
      @order = order
    end

    def capture_payments
      return if @order.paid?

      Spree::OrderMutex.with_lock!(@order) do
        uncaptured_amount = @order.display_total.cents

        payment = @order.payments.first
        amount = [uncaptured_amount, payment.money.cents].min

        if amount > 0
          payment.capture!(amount)
          uncaptured_amount -= amount
        elsif SolidusExpeditedExchanges::OrderCapturing.void_unused_payments
          payment.void_transaction!
        end
      end
    end
  end
end
