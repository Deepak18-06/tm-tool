FactoryBot.define do
  factory :team_member do
    association :team
    association :user

    after(:build) do |team_member|
      existing_member = TeamMember.find_by(team_id: team_member.team_id, user_id: team_member.user_id)
      if existing_member
        team_member.user = create(:user)
      end
    end
  end
end
