module Spree
  module Transit
    class VehiclesController < Spree::Transit::BaseController
      before_action :load_vehicle_types

      def new
        @vehicle = SpreeCmCommissioner::Vehicle.new
        super
      end

      def edit
        @vehicle = SpreeCmCommissioner::Vehicle.find_by(id: params[:id])
      end

      def load_vehicle_types
        @vehicle_types = SpreeCmCommissioner::VehicleType.where(vendor_id: current_vendor.id)
      end

      def scope
        @vehicles = SpreeCmCommissioner::Vehicle.joins(:vehicle_type).where(cm_vehicle_types: { vendor_id: current_vendor.id })
      end

      def collection
        return @collection if defined?(@collection)
        scope

        @search = scope.includes(:vehicle_type).ransack(params[:q])
        @collection = @search.result
      end

      def location_after_save
        transit_vehicles_url
      end

      def model_class
        SpreeCmCommissioner::Vehicle
      end

      def object_name
        'spree_cm_commissioner_vehicle'
      end

      def vehicle_params
        params.require(:vehicle).permit(:code, :license_plate)
      end
    end
  end
end