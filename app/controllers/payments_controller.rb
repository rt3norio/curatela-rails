# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

  def index
    @payments = Payment.includes(:primary_classification, :secondary_classification)
                       .order(created_at: :desc)
  end

  def show
  end

  def new
    @payment = Payment.new
    @payment.date = Date.current
    @primary_classifications = PrimaryClassification.order(:name)
    @secondary_classifications = []
    @cpf_cnpj_list = Payment.distinct_cpf_cnpj.pluck(:cpf_cnpj)
  end

  def create
    @payment = Payment.new(payment_params)
    @primary_classifications = PrimaryClassification.order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @cpf_cnpj_list = Payment.distinct_cpf_cnpj.pluck(:cpf_cnpj)

    if @payment.save
      redirect_to @payment, notice: 'Pagamento registrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @primary_classifications = PrimaryClassification.order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @cpf_cnpj_list = Payment.distinct_cpf_cnpj.pluck(:cpf_cnpj)
  end

  def update
    @primary_classifications = PrimaryClassification.order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @cpf_cnpj_list = Payment.distinct_cpf_cnpj.pluck(:cpf_cnpj)

    if @payment.update(payment_params)
      redirect_to @payment, notice: 'Pagamento atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    redirect_to payments_path, notice: 'Pagamento removido com sucesso.'
  end

  def secondary_classifications
    primary_id = params[:primary_classification_id]
    @secondary_classifications = SecondaryClassification.where(primary_classification_id: primary_id).order(:name)
    render json: @secondary_classifications.map { |sc| { id: sc.id, name: sc.name } }
  end

  def cpf_cnpj_suggestions
    query = params[:q] || ''
    @suggestions = Payment.distinct_cpf_cnpj
                          .where('cpf_cnpj LIKE ?', "%#{query}%")
                          .limit(20)
                          .pluck(:cpf_cnpj)
    render json: @suggestions
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:primary_classification_id, :secondary_classification_id,
                                    :description, :cpf_cnpj, :value, :date, :payment_method,
                                    :document_photo)
  end
end

