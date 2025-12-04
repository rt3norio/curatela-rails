# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def edit
    redirect_to root_path, alert: "Você só pode editar seu próprio perfil." unless @user == current_user
  end

  def update
    if @user == current_user
      update_params = user_params
      # Remove password fields if they are blank
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end

      if @user.update(update_params)
        redirect_to @user, notice: "Perfil atualizado com sucesso."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to root_path, alert: "Você só pode editar seu próprio perfil."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :profile_picture)
  end
end

