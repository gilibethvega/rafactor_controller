class CartsController < ApplicationController
  before_action :authenticate_user!

  def update
    product = params[:cart][:product_id]
    quantity = params[:cart][:quantity]

    current_order.add_product(product, quantity)

    redirect_to root_url, notice: "Product added successfuly"
  end

  def show
    @order = current_order
  end

  def pay_with_paypal
    order = Order.find(params[:cart][:order_id])
    price = order.total * 100
    response = response_pay_paypal(price)
    payment_method = PaymentMethod.find_by(code: "PEC")
    Payment.create_new_order(order, payment_method, response)
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end


  def process_paypal_payment
    details = EXPRESS_GATEWAY.details_for(params[:token])
    express_purchase_options = express_purchase(request, params[:token], details)
    price = details.params["order_total"].to_d * 100

    response = EXPRESS_GATEWAY.purchase(price, express_purchase_options)
    response_successfull(response)
  end
end
