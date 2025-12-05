# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_current_curatelado

  def index
    @payments = if @current_curatelado
                  Payment.where(curatelado_id: @current_curatelado.id)
                else
                  Payment.where(curatelado_id: nil)
                end
    @payments = @payments.includes(:primary_classification, :secondary_classification, :curator)
                         .order(created_at: :desc)
  end

  def show
  end

  def new
    @payment = Payment.new
    @payment.date = Date.current
    @payment.curatelado_id = @current_curatelado&.id
    @payment.curator_id = current_user.id
    @primary_classifications = PrimaryClassification.by_curatelado(@current_curatelado&.id).order(:name)
    @secondary_classifications = []
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]
  end

  def create
    @payment = Payment.new(payment_params)
    @payment.curatelado_id = @current_curatelado&.id
    @primary_classifications = PrimaryClassification.by_curatelado(@current_curatelado&.id).order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]

    if @payment.save
      redirect_to @payment, notice: 'Pagamento registrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @primary_classifications = PrimaryClassification.by_curatelado(@current_curatelado&.id).order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]
  end

  def update
    @primary_classifications = PrimaryClassification.by_curatelado(@current_curatelado&.id).order(:name)
    @secondary_classifications = if @payment.primary_classification_id.present?
                                   SecondaryClassification.where(primary_classification_id: @payment.primary_classification_id).order(:name)
                                 else
                                   []
                                 end
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]

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
    curatelado_id = @current_curatelado&.id
    @secondary_classifications = SecondaryClassification.where(primary_classification_id: primary_id)
                                                       .by_curatelado(curatelado_id)
                                                       .order(:name)
    render json: @secondary_classifications.map { |sc| { id: sc.id, name: sc.name } }
  end

  def cpf_cnpj_suggestions
    query = params[:q] || ''
    curatelado_id = @current_curatelado&.id
    @suggestions = Payment.partner_suggestions(query, curatelado_id)
    render json: @suggestions
  end
  
  def partner_details
    cpf_cnpj = params[:cpf_cnpj]
    curatelado_id = @current_curatelado&.id
    payment = if curatelado_id
                Payment.by_curatelado(curatelado_id).find_by(cpf_cnpj: cpf_cnpj)
              else
                Payment.find_by(cpf_cnpj: cpf_cnpj)
              end
    
    if payment
      render json: {
        partner_name: payment.partner_name,
        cpf_cnpj: payment.cpf_cnpj
      }
    else
      render json: { error: 'Partner not found' }, status: :not_found
    end
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def set_current_curatelado
    if session[:current_curatelado_id]
      @current_curatelado = current_user.curatelados.find_by(id: session[:current_curatelado_id])
    end
  end

  def payment_params
    params.require(:payment).permit(:primary_classification_id, :secondary_classification_id,
                                    :description, :cpf_cnpj, :partner_name, :value, :date, 
                                    :payment_method, :document_photo, :curator_id)
  end
end

