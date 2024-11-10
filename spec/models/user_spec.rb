require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(first_name: 'John', last_name: 'Doe', email: 'john@example.com', password: 'password', role: User::ROLES[:user]) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_inclusion_of(:role).in_array(User::ROLES.values) }
  end

  describe "default role" do
    it "sets the default role to :user" do
      user = User.new
      user.valid?
      expect(user.role).to eq(User::ROLES[:user])
    end
  end

  describe "#user?" do
    it "returns true if role is user" do
      expect(subject.user?).to be true
    end
  end

  describe "#admin?" do
    it "returns true if role is admin" do
      subject.role = User::ROLES[:admin]
      expect(subject.admin?).to be true
    end
  end
end
