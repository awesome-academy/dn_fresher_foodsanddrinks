require "rails_helper"
require "./app/helpers/sessions_helper"

RSpec.configure do |c|
  c.include SessionsHelper
end

RSpec.describe Admin::ProductsController, type: :controller do
  let(:admin){FactoryBot.create(:user, :admin)}
  let(:category){FactoryBot.create :category};
  let(:product){FactoryBot.create(:product, category_id: category.id)}
  let(:invalid_params){{name: ""}}

  before{sign_in admin}

  describe "before action" do
    it {is_expected.to use_before_action :find_product}
    it {is_expected.to use_before_action :set_locale}
  end

  # 1 - INDEX RSPEC
  describe "GET #index" do
    let!(:product_one){FactoryBot.create(:product, name: "Drinks", category_id: category.id)}
    let!(:product_two){FactoryBot.create(:product, name: "Foods",category_id: category.id)}

    before {get :index}

    it "assigns @products" do
      expect(assigns(:products)).to eq([product_one, product_two])
    end

    it "renders the #index view" do
      expect(response).to render_template :index
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/products").to(action: :index)}
  end

  # 2 - NEW RSPEC
  describe "GET #new" do

    before {get :new}
    it "assigns a new product to @admin_product" do
      expect(assigns(:admin_product)).to be_a_new(Product)
    end

    it "renders the #new view" do
      expect(response).to render_template :new
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/products/new").to(action: :new)}
  end

  # 3 - EDIT RSPEC
  describe "GET #edit" do
    before{get :edit, params:{id: product.id}}

    it "assign @product" do
      expect(assigns(:admin_product)).to eq(product)
    end

    it "renders the #edit view" do
      expect(response).to render_template :edit
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/products/1/edit").to(action: :edit, id: 1)}
  end

  # 4 - CREATE RSPEC
  describe "POST #create" do
    context "create product success" do
      before do
        post :create, params: {product:{name: "Product", information: "infomation", price: 29.33, quantity: 10, category_id: category.id}}
      end

      it "create a new product" do
        expect(assigns(:admin_product)).to be_a Product
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "admin.product.add_success"
      end

      it "redirects to the #index" do
        expect(response).to redirect_to admin_products_path
      end
    end

    context "create product fail" do
      before do
        post :create, params: {product: invalid_params}
      end
      it "re-renders the new view" do
        expect(response).to render_template :new
      end

      it "flash failed message" do
        expect(flash[:danger]).to eq I18n.t "admin.product.add_fail"
      end
    end
    it {should route(:post, "admin/products").to(action: :create)}
  end

  # 5 - UPDATE RSPEC
  describe "PATCH #update" do
    context "update product success" do

      before do
        patch :update, params: {product:{name: "Product", information: "infomation", price: 29.33, quantity: 10, category_id: category.id}, id: product.id}
      end

      it "update a product old" do
        expect(assigns(:admin_product)).to be_a Product
      end

      it "flash success message" do
        expect(flash[:success]).to eq I18n.t "admin.product.edit_success"
      end

      it "redirects to the #index" do
        expect(response).to redirect_to admin_products_path
      end
    end

    context "update product fail" do
      before do
        patch :update, params: {product:{name: "", category_id: category.id}, id: product.id}
      end
      it "re-renders the edit view" do
        expect(response).to render_template :edit
      end
      it "flash failed message" do
        expect(flash[:danger]).to eq I18n.t "admin.product.edit_fail"
      end
    end
  end

  # 6 - DESTROY RSPEC
  describe "DELETE #destroy" do
    context "destroy product success" do
      before do
        delete :destroy, params: {id: product.id}
      end
      it "flash message destroy success" do
        expect(flash[:success]).to eq I18n.t "admin.product.delete_success"
      end
      it "redirects to the #index" do
        expect(response).to redirect_to admin_products_path
      end
    end

    context "destroy product failed" do
      before do
        delete :destroy, params: {id: ""}
      end
      it "flash message not found product" do
        expect(flash[:danger]).to eq I18n.t "admin.product.not_found"
      end

      it "redirects to the #index" do
        expect(response).to redirect_to admin_products_path
      end
    end
  end
end
