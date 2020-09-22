require "rails_helper"

RSpec.describe Order, type: :model do
  let(:user){FactoryBot.create(:user, :member)}
  let!(:order){FactoryBot.create(:order, user_id: user.id)}
  let(:order_2){FactoryBot.create(:order, user_id: user.id)}
  let(:category){FactoryBot.create :category};
  let(:product_1){FactoryBot.create(:product, category_id: category.id)}
  let(:product_2){FactoryBot.create(:product, category_id: category.id)}
  let(:order_detail_1){FactoryBot.create(:order_detail, order_id: order.id, product_id: product_1.id)};
  let(:order_detail_2){FactoryBot.create(:order_detail, order_id: order.id, product_id: product_2.id)};

  subject {order}

  before do
    subject.order_details.new(
      product: order_detail_1.product,
      quantity: order_detail_1.quantity,
      current_price: order_detail_1.current_price)
    subject.order_details.new(
      product: order_detail_2.product,
      quantity: order_detail_2.quantity,
      current_price: order_detail_2.current_price)
  end

  it "is a valid factory" do
    is_expected.to be_valid
  end

  it "is a Order" do
    is_expected.to be_a_kind_of Order
  end

  describe "db schema" do
    context "columns" do
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:total).of_type(:float) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:order_details).dependent(:destroy) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to belong_to(:user).class_name("User") }
  end

  describe "enum" do
    it {is_expected.to define_enum_for(:status).with_values(
      waiting: 0,
      ordered: 1,
      confirmed: 2,
      refused: 3,
      canceled: 4
      )}
  end

  describe "#total_price" do
    it "valid - return total of order details" do
      sum = (order_detail_1.quantity * order_detail_1.current_price) + (order_detail_2.quantity * order_detail_2.current_price)
      expect(subject.total_price).to eq(sum)
    end

    it "invalid - return total 0" do
      order_2.order_details.new(
        product: nil)
      order_2.order_details.new(
        product: nil)
      expect(order_2.total_price).to eq(0)
    end
  end

  describe "#verify_order" do
    it "changed status success" do
      subject.verify_order
      expect(subject.status).to eq("ordered")
    end
  end

  describe "#update_status" do
    it "enum 2 - confirmed" do
      subject.update_status Order.statuses[:confirmed]
      expect(subject.status).to eq("confirmed")
    end
    it "case 3 - refused" do
      subject.update_status Order.statuses[:refused]
      expect(subject.status).to eq("refused")
    end
  end

  describe "#cancel" do
    it "canceled" do
      subject.cancel
      expect(subject.status).to eq("canceled")
    end
  end

  describe "#link_confirm_expired?" do
    it "check" do
      expect(subject.link_confirm_expired?).to eq(false)
    end
  end

  describe "#save_order_details" do
    before do
      subject.send(:save_order_details)
      @od1 = subject.order_details.first
      @od2 = subject.order_details.last
    end

    context "check product_1" do
      it "check quantity" do
        expect(@od1.quantity).to eq(order_detail_1.quantity)
      end
      it "check current_price" do
        expect(@od1.current_price).to eq(order_detail_1.current_price)
      end
      it "check product_id" do
        expect(@od1.product_id).to eq(order_detail_1.product_id)
      end
      it "check order_id" do
        expect(@od1.order_id).to eq(order_detail_1.order_id)
      end
    end

    context "check product_2" do
      it "check quantity" do
        expect(@od2.quantity).to eq(order_detail_2.quantity)
      end
      it "check current_price" do
        expect(@od2.current_price).to eq(order_detail_2.current_price)
      end
      it "check product_id" do
        expect(@od2.product_id).to eq(order_detail_2.product_id)
      end
      it "check order_id" do
        expect(@od2.order_id).to eq(order_detail_2.order_id)
      end
    end
  end

  describe "#update_quantity_product_minus" do
    let(:quantity_old_product_1){product_1.quantity}
    let(:quantity_old_product_2){product_2.quantity}
    before do
      subject.send(:update_quantity_product_minus)
    end
    it "check order_detail_1" do
      product1_new = Product.find_by id: product_1.id
      expect(product1_new.quantity).to eq(quantity_old_product_1-order_detail_1.quantity)
    end
    it "check order_detail_2" do
      product2_new = Product.find_by id: product_2.id
      expect(product2_new.quantity).to eq(quantity_old_product_2-order_detail_2.quantity)
    end
  end

  describe "#update_quantity_product_plus" do
    let(:quantity_old_product_1){product_1.quantity}
    let(:quantity_old_product_2){product_2.quantity}
    before do
      subject.send(:update_quantity_product_plus)
    end
    it "check order_detail_1" do
      product1_new = Product.find_by id: product_1.id
      expect(product1_new.quantity).to eq(quantity_old_product_1+order_detail_1.quantity)
    end
    it "check order_detail_2" do
      product2_new = Product.find_by id: product_2.id
      expect(product2_new.quantity).to eq(quantity_old_product_2+order_detail_2.quantity)
    end
  end
end
