module Spree
  module OrderMailerDecorator
    def confirm_email(order, resend: false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      return false if @order.email.blank?

      current_store = @order.store
      subject = (resend ? "[#{Spree.t(:resend).upcase}] " : '')
      subject += "Confirmation for Booking ID ##{@order.number}"
      mail(to: @order.email, from: from_address, subject: subject, store_url: current_store.url) do |format|
        format.html { render layout: 'spree_cm_commissioner/layouts/order_mailer' }
        format.text
      end
    end
  end
end

Spree::OrderMailer.prepend(Spree::OrderMailerDecorator)