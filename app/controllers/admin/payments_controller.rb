class Admin::PaymentsController < ApplicationController
  layout "admin"
  before_filter :authenticate_user!
  before_filter :verify_admin
  
  
  def update_payment
    #redirect_to admin_payment_url(@payment,@campaign), :flash => { :notice => "Payment Updated!" }
    @payment_new = Payment.create(params[:payment])
    @payment = Payment.find_by_ct_payment_id(params[:payment_id].strip)
    @payment.email = @payment_new.email
    @payment.fullname = @payment_new.fullname
    if( @payment.save )
      redirect_to admin_campaigns_payments_path(params[:id]), :flash => { :notice => "Payment Modified Successfully!"}
    end
  end
  
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
