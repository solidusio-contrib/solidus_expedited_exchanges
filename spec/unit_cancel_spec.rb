require 'spec_helper'

describe Spree::UnitCancel do
  let(:unit_cancel) { Spree::UnitCancel.create!(inventory_unit: inventory_unit, reason: Spree::UnitCancel::SHORT_SHIP) }
  let(:inventory_unit) { create(:inventory_unit) }

  describe '#compute_amount' do
    subject { unit_cancel.compute_amount(line_item) }

    let(:line_item) { inventory_unit.line_item }
    let!(:inventory_unit2) { create(:inventory_unit, line_item: inventory_unit.line_item) }

    context "when exchanges are present" do
      let!(:order) { create(:order, ship_address: create(:address)) }
      let!(:product) { create(:product, price: 10.00) }
      let!(:variant) do
        create(:variant, price: 10, product: product, track_inventory: false)
      end
      let!(:shipping_method) { create(:free_shipping_method) }
      let(:exchange_variant) do
        create(:variant, product: variant.product, price: 10, track_inventory: false)
      end

      before do
        Spree::Config[:expedited_exchanges] = true
      end

      # This sets up an order with one shipped inventory unit, one unshipped
      # inventory unit, and one unshipped exchange inventory unit.
      before do
        # Complete an order with 1 line item with quantity=2
        order.contents.add(variant, 2)
        order.contents.advance
        create(:payment, order: order, amount: order.total)
        order.payments.reload
        order.contents.advance
        order.complete!
        order.reload

        # Ship _one_ of the inventory units
        @shipment = order.shipments.first
        @shipped_inventory_unit = order.inventory_units[0]
        @unshipped_inventory_unit = order.inventory_units[1]
        order.shipping.ship(
          inventory_units: [@shipped_inventory_unit],
          stock_location: @shipment.stock_location,
          address: order.ship_address,
          shipping_method: @shipment.shipping_method
        )

        # Create an expedited exchange for the shipped inventory unit.
        # This generates a new inventory unit attached to the existing line item.
        Spree::ReturnAuthorization.create!(
          order: order,
          stock_location: @shipment.stock_location,
          reason: create(:return_reason),
          return_items: [
            Spree::ReturnItem.new(
              inventory_unit: @shipped_inventory_unit,
              exchange_variant: exchange_variant
            )
          ]
        )
        @exchange_inventory_unit = order.inventory_units.reload[2]
      end

      context 'when canceling an unshipped inventory unit from the original order' do
        subject do
          unit_cancel.compute_amount(@unshipped_inventory_unit.line_item)
        end

        let(:unit_cancel) do
          Spree::UnitCancel.create!(
            inventory_unit: @unshipped_inventory_unit,
            reason: Spree::UnitCancel::SHORT_SHIP
          )
        end

        it { is_expected.to eq(-10.00) }
      end

      context 'when canceling an unshipped exchange inventory unit' do
        subject do
          unit_cancel.compute_amount(@exchange_inventory_unit.line_item)
        end

        let(:unit_cancel) do
          Spree::UnitCancel.create!(
            inventory_unit: @exchange_inventory_unit,
            reason: Spree::UnitCancel::SHORT_SHIP
          )
        end

        it { is_expected.to eq(-10.00) }
      end
    end
  end
end
