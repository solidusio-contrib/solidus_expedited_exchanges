require 'spec_helper'

describe Spree::Order, type: :model do
  let(:store) { build_stubbed(:store) }
  let(:user) { stub_model(Spree::LegacyUser, email: "spree@example.com") }
  let(:order) { stub_model(Spree::Order, user: user, store: store) }

  describe "#create_proposed_shipments" do
    subject(:order) { create(:order) }
    context "unreturned exchange" do
      let!(:first_shipment) do
        create(:shipment, order: subject, state: first_shipment_state, created_at: 5.days.ago)
      end
      let!(:second_shipment) do
        create(:shipment, order: subject, state: second_shipment_state, created_at: 5.days.ago)
      end

      context "all shipments are shipped" do
        let(:first_shipment_state) { "shipped" }
        let(:second_shipment_state) { "shipped" }

        it "returns the shipments" do
          subject.create_proposed_shipments
          expect(subject.shipments).to match_array [first_shipment, second_shipment]
        end
      end
    end
  end

  describe "#unreturned_exchange?" do
    let(:order) { create(:order_with_line_items) }
    subject { order.reload.unreturned_exchange? }

    context "the order does not have a shipment" do
      before { order.shipments.destroy_all }

      it { is_expected.to be false }
    end

    context "shipment created after order" do
      it { is_expected.to be false }
    end

    context "shipment created before order" do
      before do
        order.shipments.first.update_attributes!(created_at: order.created_at - 1.day)
      end

      it { is_expected.to be true }
    end
  end

  describe '.unreturned_exchange' do
    let(:order) { create(:order_with_line_items) }
    subject { described_class.unreturned_exchange }

    it 'includes orders that have a shipment created prior to the order' do
      order.shipments.first.update_attributes!(created_at: order.created_at - 1.day)
      expect(subject).to include order
    end

    it 'excludes orders that were created prior to their shipment' do
      expect(subject).not_to include order
    end

    it 'excludes orders with no shipment' do
      order.shipments.destroy_all
      expect(subject).not_to include order
    end
  end
end
