require 'rails_helper'

RSpec.describe "TeamMembers APIs", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:team) { create(:team, owner: user) }
  let!(:another_team) { create(:team, owner: admin) }
  let!(:another_user) { create(:user) }

  def add_team_member(team_id, user_id, user)
    post "/teams/#{team_id}/team_members", params: { user_id: user_id }, headers: auth_header(user)
  end

  context 'when the user is an admin' do
    it 'can add a user to the team' do
      expect {
        add_team_member(team.id, another_user.id, admin)
      }.to change { team.team_members.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response.body).to include("User added to the team")
    end
  end

  context 'when the user is the team owner' do
    it 'can add a user to the team' do
      expect {
        add_team_member(team.id, another_user.id, user)
      }.to change { team.team_members.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(response.body).to include("User added to the team")
    end
  end

  context 'when the user is neither an admin nor the team owner' do
    it 'cannot add a user to the team' do
      expect {
        add_team_member(team.id, another_user.id, another_user)
      }.not_to change { team.team_members.count }

      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("You are not authorized to manage members in this team")
    end
  end

  context 'when the team or user is not found' do
    it 'returns an error if the team is not found' do
      post "/teams/999/team_members", params: { user_id: another_user.id }, headers: auth_header(admin)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Couldn't find Team")
    end

    it 'returns an error if the user is not found' do
      post "/teams/#{team.id}/team_members", params: { user_id: 999 }, headers: auth_header(admin)

      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("Couldn't find User")
    end
  end
end
