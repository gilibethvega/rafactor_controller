class PaymentMethod < ApplicationRecord
  has_many :payments
  def self.create_order(order, payment_method, response)
    self.create(
      order_id: order.id,
      payment_method_id: payment_method.id,
      state: "processing",
      total: order.total,
      token: response.token
    )
  end

  def express_purchase(request, token, deatils)
    {
      ip: request.remote_ip,
      token: token,
      payer_id: details.payer_id,
      currency: "USD"
    }
  end
end
