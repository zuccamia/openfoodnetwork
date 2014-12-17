module OpenFoodNetwork
  # Variants can have several fields overridden on a per-enterprise basis by the
  # VariantOverride model. These overrides can be applied to variants by wrapping in an
  # instance of the VariantProxy class. This class proxies most methods back to the wrapped
  # variant, but checks for overrides when fetching some properties.
  class VariantProxy
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(variant, hub)
      @variant = variant
      @hub = hub
    end

    def price
      VariantOverride.price_for(@hub, @variant) || @variant.price
    end

    def price_with_fees(distributor, order_cycle)
      price + @variant.fees_for(distributor, order_cycle)
    end


    def method_missing(name, *args, &block)
      @variant.send(name, *args, &block)
    end
  end
end
