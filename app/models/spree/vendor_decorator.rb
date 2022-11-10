module Spree
  module VendorDecorator
    def self.prepended(base)
      base.has_one  :logo, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorLogo'
    end
  end
end

Spree::Vendor.prepend(Spree::VendorDecorator)