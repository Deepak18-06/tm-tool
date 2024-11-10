class TeamsController < ApplicationController
  before_action :authorize_admin_or_owner

  def index
    @teams = Team.includes(:users).all
    render json: @teams, include: [ "users" ]
  end

  def show
    @team = Team.includes(:users).find(params[:id])
    render json: @team, include: [ "users" ]
  end

  def create
    owner = User.find_by(id: team_params[:owner])

    unless owner
      return render json: { errors: [ "Owner does not exist" ] }, status: :unprocessable_entity
    end

    @team = Team.new(team_params.merge(owner: owner))

    if @team.save
      render json: @team, status: :created
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    @team = Team.find(params[:id])
    if @team.update(team_update_params)
      render json: @team
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    head :no_content
  end

  private

  def require_admin
    unless current_user&.admin?
      render json: { error: "Only admins can create teams" }, status: :forbidden
    end
  end

  def authorize_admin_or_owner
    team = Team.find_by(id: params[:id] || params[:id])

    unless current_user&.admin? || (team && team.owner == current_user)
      render json: { error: "You are not authorized to manage members in this team" }, status: :forbidden
    end
  end


  def team_params
    params.require(:team).permit(:name, :description, :owner)
  end

  def team_update_params
    params.require(:team).permit(:name, :description)
  end
end
