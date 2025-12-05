# frozen_string_literal: true

class ReimbursementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reimbursement, only: [:show, :edit, :update, :destroy]

  def index
    @reimbursements = Reimbursement.includes(:payments).order(created_at: :desc)
  end

  def show
  end

  def new
    @reimbursement = Reimbursement.new
    @payments = Payment.where(reimbursement_code: [nil, '']).order(created_at: :desc)
  end

  def create
    @reimbursement = Reimbursement.new(reimbursement_params)
    @payments = Payment.where(reimbursement_code: [nil, '']).order(created_at: :desc)

    if @reimbursement.save
      # Associar pagamentos selecionados
      if params[:payment_ids].present?
        payment_ids = params[:payment_ids].reject(&:blank?)
        @reimbursement.payments << Payment.where(id: payment_ids)
        
        # Atualizar código de reembolso nos pagamentos
        Payment.where(id: payment_ids).update_all(reimbursement_code: @reimbursement.code)
      end

      redirect_to @reimbursement, notice: 'Reembolso registrado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @payments = Payment.order(created_at: :desc)
  end

  def update
    if @reimbursement.update(reimbursement_params)
      # Atualizar associações de pagamentos
      if params[:payment_ids].present?
        payment_ids = params[:payment_ids].reject(&:blank?).map(&:to_i)
        
        # Remover código de reembolso dos pagamentos que não estão mais associados
        @reimbursement.payments.where.not(id: payment_ids).update_all(reimbursement_code: nil)
        
        # Remover associações antigas que não estão mais selecionadas
        @reimbursement.payment_reimbursements.where.not(payment_id: payment_ids).destroy_all
        
        # Adicionar novos pagamentos e atualizar código
        Payment.where(id: payment_ids).each do |payment|
          unless @reimbursement.payment_ids.include?(payment.id)
            @reimbursement.payments << payment
          end
          payment.update_column(:reimbursement_code, @reimbursement.code)
        end
      else
        # Se nenhum pagamento foi selecionado, remover todos
        @reimbursement.payments.update_all(reimbursement_code: nil)
        @reimbursement.payments.clear
      end

      redirect_to @reimbursement, notice: 'Reembolso atualizado com sucesso.'
    else
      @payments = Payment.order(created_at: :desc)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Remover código de reembolso dos pagamentos associados
    @reimbursement.payments.update_all(reimbursement_code: nil)
    @reimbursement.destroy
    redirect_to reimbursements_path, notice: 'Reembolso removido com sucesso.'
  end

  private

  def set_reimbursement
    @reimbursement = Reimbursement.find(params[:id])
  end

  def reimbursement_params
    params.require(:reimbursement).permit(:code, :reimbursement_proof)
  end
end

