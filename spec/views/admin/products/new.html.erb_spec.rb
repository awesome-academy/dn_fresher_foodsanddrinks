require "rails_helper"

RSpec.describe "admin/products/new.html.erb", type: :view do
  let(:admin_product) {Product.new}
  let(:category) {Category.alphabet_name}
  subject {rendered}

  before do
    assign :admin_product, admin_product
    assign :categories, category
    render
  end

  describe "form create" do
    it {is_expected.to have_field "product_name"}

    it {is_expected.to have_field "product_category_id"}

    it {is_expected.to have_field "product_price"}

    it {is_expected.to have_field "product_quantity"}

    it {is_expected.to have_field "product_information"}

    it {have_submit_button(I18n.t("admin.product.new"))}

    it {is_expected.to render_template(partial: "_form")}
  end
end
