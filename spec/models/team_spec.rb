require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:owner) { create(:user) }
  let(:team) { build(:team, owner: owner) }

  describe "Associations" do
    it { is_expected.to belong_to(:owner).class_name("User") }
    it { is_expected.to have_many(:team_members).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:team_members) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:owner) }
  end

  describe "#valid?" do
    it "is valid with valid attributes" do
      expect(team).to be_valid
    end

    it "is invalid without a name" do
      team.name = nil
      expect(team).not_to be_valid
      expect(team.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a description" do
      team.description = nil
      expect(team).not_to be_valid
      expect(team.errors[:description]).to include("can't be blank")
    end

    it "is invalid without an owner" do
      team.owner = nil
      expect(team).not_to be_valid
      expect(team.errors[:owner]).to include("can't be blank")
    end
  end
end
