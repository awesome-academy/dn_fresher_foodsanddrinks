require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category){FactoryBot.create :category}

  subject {category}

  it "is a valid factory" do
    is_expected.to be_valid
  end

  it "is a Category" do
    is_expected.to be_a_kind_of Category
  end

  describe "db schema" do
    context "columns" do
      it {is_expected.to have_db_column(:name).of_type(:string)}
    end
  end

  describe "associations" do
    it {is_expected.to have_many(:products).dependent(:destroy)}
  end

  describe "validations" do
    context "name" do
      it {is_expected.to validate_presence_of(:name)
        .with_message(I18n.t("errors.messages.blank"))}
    end
  end

  describe "scopes" do
    before(:all) do
      @category_1 = create(:category, name: "Foods")
      @category_2 = create(:category, name: "Drinks")
    end

    it "orders by alphabet name" do
      Category.alphabet_name.should eq [@category_2, @category_1]
    end
  end
end
