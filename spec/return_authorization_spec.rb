require 'spec_helper'

describe Spree::ReturnAuthorization, type: :model do
  let(:order) { create(:shipped_order) }
  let(:stock_location) { create(:stock_location) }
  let(:rma_reason) { create(:return_reason) }
  let(:inventory_unit_1) { order.inventory_units.first }

  let(:variant) { order.variants.first }
  let(:return_authorization) do
    Spree::ReturnAuthorization.new(order: order,
      stock_location_id: stock_location.id,
      return_reason_id: rma_reason.id)
  end

  context "save" do
    let(:order) { Spree::Order.create }

    context "expedited exchanges are configured" do
      let(:order)                { create(:shipped_order, line_items_count: 2) }
      let(:exchange_return_item) { build(:exchange_return_item, inventory_unit: order.inventory_units.first) }
      let(:return_item)          { build(:return_item, inventory_unit: order.inventory_units.last) }
      subject                    { create(:return_authorization, order: order, return_items: [exchange_return_item, return_item]) }

      before do
        stub_spree_preferences(Spree::Config, expedited_exchanges: true)
        @pre_exchange_hooks = subject.class.pre_expedited_exchange_hooks
      end

      after do
        subject.class.pre_expedited_exchange_hooks = @pre_exchange_hooks
      end

      context "no items to exchange" do
        subject { create(:return_authorization, order: order) }

        it "does not create a reimbursement" do
          expect{ subject.save }.to_not change { Spree::Reimbursement.count }
        end
      end

      context "items to exchange" do
        it "calls pre_expedited_exchange hooks with the return items to exchange" do
          hook = double(:as_null_object)
          expect(hook).to receive(:call).with [exchange_return_item]
          subject.class.pre_expedited_exchange_hooks = [hook]
          subject.save
        end

        it "attempts to accept all return items requiring exchange" do
          expect(exchange_return_item).to receive :attempt_accept
          expect(return_item).not_to receive :attempt_accept
          subject.save
        end

        it "performs an exchange reimbursement for the exchange return items" do
          subject.save
          reimbursement = Spree::Reimbursement.last
          expect(reimbursement.order).to eq subject.order
          expect(reimbursement.return_items).to eq [exchange_return_item]
          expect(exchange_return_item.reload.exchange_shipment).to be_present
        end

        context "the reimbursement fails" do
          before do
            allow_any_instance_of(Spree::Reimbursement).to receive(:save) { false }
            allow_any_instance_of(Spree::Reimbursement).to receive(:errors) { double(full_messages: "foo") }
          end

          it "puts errors on the return authorization" do
            subject.save
            expect(subject.errors[:base]).to include "foo"
          end
        end
      end
    end
  end
end
