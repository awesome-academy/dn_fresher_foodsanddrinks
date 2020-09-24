require "rails_helper"
require "./app/helpers/sessions_helper"

RSpec.configure do |c|
  c.include SessionsHelper
end

RSpec.describe OrdersController, type: :controller do
  let(:user){FactoryBot.create(:user, :admin)}
  let(:order){FactoryBot.create(:order, user_id: user.id)}
  let(:category){FactoryBot.create :category};
  let(:product_1){FactoryBot.create(:product, category_id: category.id)}
  let(:product_2){FactoryBot.create(:product, category_id: category.id)}

  before do
    sign_in user
    cart = current_cart
    cart.store(product_1.id, 1)
    cart.store(product_2.id, 1)
  end

  describe "before action" do
    it {is_expected.to use_before_action :load_order_from_cart}
    it {is_expected.to use_before_action :find_order}
    it {is_expected.to use_before_action :load_user}
    it {is_expected.to use_before_action :check_order}
  end

  # 1 - SHOW RSPEC
  describe "GET #show" do
    context "show order success" do
      before do
        get :show, params:{id: order.id}
      end

      it "renders the #show view" do
        expect(response).to render_template :show
      end

      it "returns a http status 200" do
        expect(response).to have_http_status 200
      end
    end

    context "when not found Order" do
      before do
        get :show, params:{id: 0}
      end

      it "redirect_to Home page" do
        expect(response).to redirect_to root_path
      end

      it "flash not found message" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.not_found"
      end
    end
    it {should route(:get, "orders/1").to(action: :show, id: 1)}
  end

  # 2 - NEW RSPEC
  describe "GET #new" do
    context "when new order success" do
      before do
        get :new
      end

      it "renders the #new view" do
        expect(response).to render_template :new
      end

      it "returns a http status 200" do
        expect(response).to have_http_status 200
      end
    end

    context "when cart is blank" do
      before do
        session.delete :cart
        get :new
      end

      it "redirects to the root_path" do
        expect(response).to redirect_to root_path
      end

      it "returns a http status 302" do
        expect(response).to have_http_status 302
      end

      it "flash fail message" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.blank"
      end
    end

    context "when product is nil" do
      before do
        session.delete :cart
        cart = current_cart
        cart.store(11, 1)
        get :new
      end

      it "redirects to the root_path" do
        expect(response).to redirect_to root_path
      end
    end

    it {should route(:get, "orders/new").to(action: :new)}
  end

  # 3 - CREATE RSPEC
  describe "POST #create" do

    context "create order success" do
      before do
        post :create, params: {order:{email: "ngocman@gmail.com"}}
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "controllers.orders.save_success"
      end

      it "redirects to the #show" do
        @order = user.orders.last
        expect(response).to redirect_to order_path(@order)
      end
    end

    context "create order fail" do

      before do
        allow(controller).to receive(:load_user).and_return(true)
        post :create, params: {order:{email: nil}}
      end

      it "flash fail message" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.save_fail"
      end

      it "renders the #new view" do
        expect(response).to render_template :new
      end
    end
  end

  # 4 - UPDATE RSPEC
  describe "PATCH #update" do
    context "update status order success" do

      before do
        patch :update, params: {status: Order.statuses[:canceled], id: order.id}
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "controllers.orders.cancel_success"
      end

      it "redirects to the current_user" do
        expect(response).to redirect_to user
      end
    end

    context "status error" do

      before do
        patch :update, params: {status: Order.statuses[:confirmed], id: order.id}
      end

      it "flash status error" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.status_error"
      end

      it "redirects to the current_user" do
        expect(response).to redirect_to user
      end
    end

    context "status error when before action" do
      let(:order_invalid){FactoryBot.create(:order, user_id: user.id, status: Order.statuses[:confirmed])}

      before do
        patch :update, params: {id: order_invalid.id}
      end

      it "flash status error" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.status_error"
      end

      it "redirects to the current_user" do
        expect(response).to redirect_to user
      end
    end

    context "update status order fail" do

      before do
        allow(controller).to receive(:find_order).and_return(true)
        allow(controller).to receive(:check_order).and_return(true)
        patch :update, params: {status: Order.statuses[:canceled], id: order.id}
        @order = user.orders.find_by id: order.id
        @order.user_id = nil
      end

      it "redirects to the current_user" do
        expect(response).to redirect_to user
      end

      it "flash update status fail" do
        expect(flash[:danger]).to eq I18n.t "controllers.orders.cancel_fail"
      end
    end
  end
end
