# frozen_string_literal: true

class ClassificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_curatelado

  def index
    @primary_classifications = if @current_curatelado
                                  PrimaryClassification.where(curatelado_id: @current_curatelado.id)
                                else
                                  PrimaryClassification.where(curatelado_id: nil)
                                end
    @primary_classifications = @primary_classifications.includes(:secondary_classifications).order(:name)
  end

  def create_primary
    @primary_classification = PrimaryClassification.new(name: params[:name])
    @primary_classification.curatelado_id = @current_curatelado&.id
    if @primary_classification.save
      redirect_to classifications_path, notice: 'Classificação primária criada com sucesso.'
    else
      redirect_to classifications_path, alert: "Erro ao criar classificação: #{@primary_classification.errors.full_messages.join(', ')}"
    end
  end

  def create_secondary
    @primary_classification = PrimaryClassification.find(params[:primary_classification_id])
    @secondary_classification = @primary_classification.secondary_classifications.new(name: params[:name])
    @secondary_classification.curatelado_id = @current_curatelado&.id
    if @secondary_classification.save
      redirect_to classifications_path, notice: 'Classificação secundária criada com sucesso.'
    else
      redirect_to classifications_path, alert: "Erro ao criar classificação: #{@secondary_classification.errors.full_messages.join(', ')}"
    end
  end

  def destroy_primary
    @primary_classification = PrimaryClassification.find(params[:id])
    @primary_classification.destroy
    redirect_to classifications_path, notice: 'Classificação primária removida com sucesso.'
  end

  def destroy_secondary
    @secondary_classification = SecondaryClassification.find(params[:id])
    @secondary_classification.destroy
    redirect_to classifications_path, notice: 'Classificação secundária removida com sucesso.'
  end
  
  private
  
  def set_current_curatelado
    if session[:current_curatelado_id]
      @current_curatelado = current_user.curatelados.find_by(id: session[:current_curatelado_id])
    end
  end
end

