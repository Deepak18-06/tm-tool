require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:team_member) }

    it { should validate_uniqueness_of(:team_id).scoped_to(:user_id) }
  end

  describe 'factory' do
    it 'is valid with valid attributes' do
      team_member = build(:team_member)
      expect(team_member).to be_valid
    end
  end
end
