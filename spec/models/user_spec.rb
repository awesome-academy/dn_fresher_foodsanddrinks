require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.create(:user, :member)}

  subject {user}

  it "is a valid factory" do
    is_expected.to be_valid
  end

  it "is a User" do
    is_expected.to be_a_kind_of User
  end

  describe "callback" do
    it "user downcase email" do
      is_expected.to receive(:downcase_email)
      user.run_callbacks(:save)
    end
  end

  describe "db schema" do
    context "columns" do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:password_digest).of_type(:string) }
      it { is_expected.to have_db_column(:address).of_type(:string) }
      it { is_expected.to have_db_column(:phone).of_type(:string) }
      it { is_expected.to have_db_column(:role).of_type(:integer) }
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:rates).dependent(:destroy) }
    it { is_expected.to have_many(:product_rates) }
    it { is_expected.to have_many(:suggests).dependent(:destroy) }
  end

  describe "validations" do
    context "name" do
      it {is_expected.to validate_presence_of(:name)
        .with_message(I18n.t("errors.messages.blank"))}

      it {is_expected.to validate_length_of(:name).is_at_most(
        Settings.validation.user.name_max)}

      it {is_expected.to validate_length_of(:name).with_message(I18n.t("errors.messages.too_long"))}
    end

    context "email" do
      it {is_expected.to validate_presence_of(:email)
        .with_message(I18n.t("errors.messages.blank"))}

      it {is_expected.to validate_length_of(:email).is_at_most(
        Settings.validation.user.email_max)}

      it {is_expected.to validate_length_of(:email).with_message(I18n.t("errors.messages.too_long"))}

      it {is_expected.to validate_uniqueness_of(:email).with_message(I18n.t("errors.messages.taken"))}

      it "email valid" do
        is_expected.to allow_value("valid@gmail.com").for(:email)
      end

      it "email is invalid" do
        is_expected.not_to allow_value("invalid").for(:email)
      end
    end

    context "address" do
      it {is_expected.to validate_presence_of(:address)
        .with_message(I18n.t("errors.messages.blank"))}
    end

    context "phone" do
      it {is_expected.to validate_presence_of(:phone)
        .with_message(I18n.t("errors.messages.blank"))}

      it "phone valid" do
        is_expected.to allow_value("0123456789").for(:phone)
      end

      it "phone is invalid" do
        is_expected.not_to allow_value("123123").for(:phone)
      end
    end

    context "password" do
      it {is_expected.to validate_length_of(:password).is_at_least(
        Settings.validation.user.pass_min)}

      it {is_expected.to validate_length_of(:password).with_message(I18n.t("errors.messages.too_short"))}

      it "password valid" do
        is_expected.to allow_value("123132").for(:password)
      end

      it "password is invalid" do
        is_expected.not_to allow_value("12345").for(:password)
      end
    end
  end

  describe "enum" do
    it {is_expected.to define_enum_for(:role).with_values(
      member: 0,
      admin: 1
    )}
  end
  describe "accept nested attributes for" do
    it {is_expected.to accept_nested_attributes_for(:images)
        .allow_destroy(true)}
  end
end
