# frozen_string_literal: true

class PartnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_curatelado
  before_action :set_partner, only: [:show, :edit, :update, :destroy]

  def index
    @partners = if @current_curatelado
                  Partner.where(curatelado_id: @current_curatelado.id)
                else
                  Partner.where(curatelado_id: nil)
                end
    @partners = @partners.order(:name)
  end

  def show
  end

  def new
    @partner = Partner.new
    @partner.curatelado_id = @current_curatelado&.id
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.curatelado_id = @current_curatelado&.id

    if @partner.save
      redirect_to @partner, notice: 'Parceiro criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @partner.update(partner_params)
      redirect_to @partner, notice: 'Parceiro atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partner.destroy
    redirect_to partners_path, notice: 'Parceiro removido com sucesso.'
  end

  private

  def set_partner
    @partner = Partner.find(params[:id])
  end
  
  def set_current_curatelado
    if session[:current_curatelado_id]
      @current_curatelado = current_user.curatelados.find_by(id: session[:current_curatelado_id])
    end
  end

  def partner_params
    params.require(:partner).permit(:name, :cpf_cnpj)
  end
end
