# frozen_string_literal: true

class ReimbursementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reimbursement, only: [:show, :edit, :update, :destroy]
  before_action :set_current_curatelado

  def index
    @reimbursements = if @current_curatelado
                        Reimbursement.where(curatelado_id: @current_curatelado.id)
                      else
                        Reimbursement.where(curatelado_id: nil)
                      end
    @reimbursements = @reimbursements.includes(:payments, :curator).order(created_at: :desc)
    
    # Calculate reimbursement totals by curator
    if @current_curatelado
      @curator_totals = calculate_curator_totals(@current_curatelado)
    end
  end

  def show
  end

  def new
    @reimbursement = Reimbursement.new
    @reimbursement.curatelado_id = @current_curatelado&.id
    @payments = if @current_curatelado
                  Payment.where(curatelado_id: @current_curatelado.id, reimbursement_code: [nil, ''])
                else
                  Payment.where(curatelado_id: nil, reimbursement_code: [nil, ''])
                end.order(created_at: :desc)
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]
  end

  def create
    @reimbursement = Reimbursement.new(reimbursement_params)
    @reimbursement.curatelado_id = @current_curatelado&.id
    @payments = if @current_curatelado
                  Payment.where(curatelado_id: @current_curatelado.id, reimbursement_code: [nil, ''])
                else
                  Payment.where(curatelado_id: nil, reimbursement_code: [nil, ''])
                end.order(created_at: :desc)
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]

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
    @payments = if @current_curatelado
                  Payment.where(curatelado_id: @current_curatelado.id)
                else
                  Payment.where(curatelado_id: nil)
                end.order(created_at: :desc)
    @curators = @current_curatelado ? @current_curatelado.curators : [current_user]
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
      @payments = if @current_curatelado
                    Payment.where(curatelado_id: @current_curatelado.id)
                  else
                    Payment.where(curatelado_id: nil)
                  end.order(created_at: :desc)
      @curators = @current_curatelado ? @current_curatelado.curators : [current_user]
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
  
  def set_current_curatelado
    if session[:current_curatelado_id]
      @current_curatelado = current_user.curatelados.find_by(id: session[:current_curatelado_id])
    end
  end

  def reimbursement_params
    params.require(:reimbursement).permit(:code, :reimbursement_proof, :curator_id)
  end
  
  def calculate_curator_totals(curatelado)
    curators_data = {}
    
    curatelado.curators.each do |curator|
      payments = Payment.where(curatelado_id: curatelado.id, curator_id: curator.id)
      reimbursed_payments = payments.where.not(reimbursement_code: [nil, ''])
      pending_payments = payments.where(reimbursement_code: [nil, ''])
      
      curators_data[curator] = {
        total: payments.sum(:value),
        reimbursed: reimbursed_payments.sum(:value),
        pending: pending_payments.sum(:value),
        payment_count: payments.count,
        pending_count: pending_payments.count
      }
    end
    
    curators_data
  end
end

