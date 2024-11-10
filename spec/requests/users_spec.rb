require 'rails_helper'

RSpec.describe "Users API", type: :request do
  let(:valid_user_attributes) do
    {
      user: {
        first_name: "John",
        last_name: "Doe",
        email: "johndoe@example.com",
        password: "password",
        password_confirmation: "password"
      }
    }
  end

  let(:invalid_user_attributes) do
    {
      user: {
        first_name: "",
        last_name: "",
        email: "invalidemail",
        password: "pass",
        password_confirmation: "different_pass"
      }
    }
  end

  describe "POST /signup" do
    context "with valid parameters" do
      it "creates a new user and returns a success message" do
        expect {
          post "/signup", params: valid_user_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("message" => "User created successfully")
      end
    end

    context "with invalid parameters" do
      it "does not create a new user and returns errors" do
        post "/signup", params: invalid_user_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("errors")
      end
    end
  end

  describe "POST /login" do
    let!(:user) { User.create(valid_user_attributes[:user]) }

    context "with valid credentials" do
      it "returns a JWT token and success message" do
        post "/login", params: { user: { email: user.email, password: "password" } }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to include("message" => "Login successful")
        expect(body).to have_key("token")
      end
    end

    context "with invalid credentials" do
      it "returns an unauthorized status and error message" do
        post "/login", params: { user: { email: user.email, password: "wrongpassword" } }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include("error" => "Invalid email or password")
      end
    end
  end
end
