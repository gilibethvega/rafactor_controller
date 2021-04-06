class ApplicationController < ActionController::Base

  def current_order
    if current_user
      order = Order.where(user_id: current_user.id).where(state: "created").last
      if order.nil?
        order = Order.create(user: current_user, state: "created")
      end
      return order
    end

    nil
  end

  def response_pay_paypal(variable)
    response = EXPRESS_GATEWAY.setup_purchase(
      variable,
      ip: request.remote_ip,
      return_url: process_paypal_payment_cart_url,
      cancel_return_url: root_url,
      allow_guest_checkout: true,
      currency: "USD"
    )
  end

  def response_successfull
    if response.success?
      payment = Payment.find_by(token: response.token)
      order = payment.order

      payment.state = "completed"
      order.state = "completed"

      ActiveRecord::Base.transaction do
        order.save!
        payment.save!
      end
    end
  end
end
