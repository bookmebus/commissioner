module SpreeCmCommissioner
  module ProductDelegation
    extend ActiveSupport::Concern

    included do
      delegate :product_type,
               :need_confirmation?, :need_confirmation, :kyc,
               :accommodation?, :service?, :ecommerce?,
               to: :product
    end
  end
end
