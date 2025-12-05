# frozen_string_literal: true

class ClassificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @primary_classifications = PrimaryClassification.includes(:secondary_classifications).order(:name)
  end

  def create_primary
    @primary_classification = PrimaryClassification.new(name: params[:name])
    if @primary_classification.save
      redirect_to classifications_path, notice: 'Classificação primária criada com sucesso.'
    else
      redirect_to classifications_path, alert: "Erro ao criar classificação: #{@primary_classification.errors.full_messages.join(', ')}"
    end
  end

  def create_secondary
    @primary_classification = PrimaryClassification.find(params[:primary_classification_id])
    @secondary_classification = @primary_classification.secondary_classifications.new(name: params[:name])
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
end

