FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    description { "Team description" }
    association :owner, factory: :user, strategy: :build

    after(:create) do |team|
      create_list(:user, 3, teams: [ team ])
    end
  end
end
