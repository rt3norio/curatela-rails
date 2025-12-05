# frozen_string_literal: true

class CurateladosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_curatelado, only: [:show, :edit, :update, :destroy, :add_curator, :remove_curator]
  before_action :authorize_owner, only: [:edit, :update, :destroy, :add_curator, :remove_curator]

  def index
    @curatelados = current_user.curatelados.order(created_at: :desc)
  end

  def show
    @curators = @curatelado.curators
  end

  def new
    @curatelado = Curatelado.new
  end

  def create
    @curatelado = Curatelado.new(curatelado_params)
    
    if @curatelado.save
      # Add current user as owner
      @curatelado.curatelado_curators.create!(user: current_user, is_owner: true)
      redirect_to @curatelado, notice: 'Curatelado criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_curators = User.where.not(id: @curatelado.curator_ids)
  end

  def update
    if @curatelado.update(curatelado_params)
      redirect_to @curatelado, notice: 'Curatelado atualizado com sucesso.'
    else
      @available_curators = User.where.not(id: @curatelado.curator_ids)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @curatelado.destroy
    redirect_to curatelados_path, notice: 'Curatelado removido com sucesso.'
  end

  def add_curator
    user = User.find(params[:user_id])
    unless @curatelado.curators.include?(user)
      @curatelado.curatelado_curators.create!(user: user, is_owner: false)
      redirect_to edit_curatelado_path(@curatelado), notice: 'Co-curador adicionado com sucesso.'
    else
      redirect_to edit_curatelado_path(@curatelado), alert: 'Este usuário já é um curador.'
    end
  end

  def remove_curator
    curator = @curatelado.curatelado_curators.find_by(user_id: params[:user_id])
    if curator && !curator.is_owner
      curator.destroy
      redirect_to edit_curatelado_path(@curatelado), notice: 'Co-curador removido com sucesso.'
    else
      redirect_to edit_curatelado_path(@curatelado), alert: 'Não é possível remover o proprietário.'
    end
  end

  def select
    session[:current_curatelado_id] = params[:id]
    redirect_back(fallback_location: root_path, notice: 'Curatelado selecionado.')
  end

  private

  def set_curatelado
    @curatelado = current_user.curatelados.find(params[:id])
  end

  def authorize_owner
    unless @curatelado.owner == current_user
      redirect_to curatelados_path, alert: 'Você não tem permissão para realizar esta ação.'
    end
  end

  def curatelado_params
    params.require(:curatelado).permit(:name, :description)
  end
end
