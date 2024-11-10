require 'rails_helper'

RSpec.describe "Teams API", type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:team) { create(:team, owner: admin_user) }

  let(:valid_team_attributes) do
    {
      team: {
        name: "New Team",
        description: "Team description",
        owner: admin_user.id
      }
    }
  end

  let(:invalid_team_attributes) do
    {
      team: {
        name: "",
        description: ""
      }
    }
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
  end

  describe "GET /teams" do
    it "returns a list of teams" do
      create_list(:team, 3, owner: admin_user)
      get "/teams"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /teams/:id" do
    it "returns a specific team with its users" do
      get "/teams/#{team.id}"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["id"]).to eq(team.id)
    end
  end

  describe "POST /teams" do
    context "when user is an admin" do
      it "creates a new team with valid attributes" do
        post "/teams", params: valid_team_attributes
        team_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(team_response["name"]).to eq("New Team")
      end

      it "returns errors with invalid attributes" do
        post "/teams", params: invalid_team_attributes

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end

    context "when user is not an admin" do
      before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user) }

      it "returns a forbidden status" do
        post "/teams", params: valid_team_attributes

        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)["error"]).to eq("You are not authorized to manage members in this team")
      end
    end
  end

  describe "PATCH /teams/:id" do
    it "updates a team with valid attributes" do
      patch "/teams/#{team.id}", params: { team: { name: "Updated Name" } }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["name"]).to eq("Updated Name")
    end

    it "returns errors with invalid attributes" do
      patch "/teams/#{team.id}", params: { team: { name: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("errors")
    end
  end

  describe "DELETE /teams/:id" do
    it "deletes a team" do
      team_to_delete = create(:team, owner: admin_user)

      expect {
        delete "/teams/#{team_to_delete.id}"
      }.to change(Team, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
