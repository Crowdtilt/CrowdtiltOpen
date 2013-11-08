class Admin::PaymentsController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin

  def refund_payment
    payment = Payment.where(:ct_payment_id => params[:id]).first
    if not payment
      logger.info({msg: 'Payment not found', ct_payment_id: params[:id]})
      render :json => {ct_payment_id: params[:id]}, :status => 404 and return
    end
    payment.refund!
  rescue RuntimeError => err
    logger.error({msg: err.message, ct_payment_id: params[:id]})
    render :json => {ct_payment_id: params[:id], status: payment.status}, :status => 500
  else
    logger.info({msg: 'Payment successfully refunded', ct_payment_id: params[:id]})
    render :json => {ct_payment_id: params[:id], status: "refunded"}, :status => 200
  end
  
end
