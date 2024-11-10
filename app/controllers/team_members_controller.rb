class TeamMembersController < ApplicationController
  before_action :authorize_admin_or_owner

  def create
    team = Team.find(params[:team_id])
    user = User.find(params[:user_id])
    team_member = team.team_members.new(user: user)

    if team_member.save
      render json: { message: "User added to the team" }, status: :created
    else
      render json: { error: team_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    team = Team.find(params[:team_id])
    team_member = team.team_members.find_by(user_id: params[:user_id])

    if team_member
      team_member.destroy
      render json: { message: "User removed from the team" }, status: :ok
    else
      render json: { error: "Team member not found" }, status: :not_found
    end
  end


  def index
    team = Team.find(params[:team_id])
    team_members = team.team_members.includes(:user)

    if params[:last_name].present?
      team_members = team_members.joins(:user).where("users.last_name ILIKE ?", "%#{params[:last_name]}%")
    end

    render json: team_members.map { |member| member.user.slice(:id, :first_name, :last_name, :email) }, status: :ok
  end

  def show
    team = Team.find(params[:team_id])
    team_member = team.team_members.find_by(user_id: params[:id])
    if team_member
      render json: team_member.user.slice(:id, :first_name, :last_name, :email, :role), status: :ok
    else
      render json: { error: "Team member not found" }, status: :not_found
    end
  end

  private

  def authorize_admin_or_owner
    team = Team.find(params[:team_id])
    unless current_user&.admin? || team.owner == current_user
      render json: { error: "You are not authorized to manage members in this team" }, status: :forbidden
    end
  end
end
