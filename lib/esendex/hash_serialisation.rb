# Handles serialisation and deserialisation of object as a hash
# 
module Esendex
  module HashSerialisation
    def initialize(attrs={})
      attrs.each_pair do |k, v|
        raise ArgumentError.new("#{k} not an attribute of #{self.class.name}") unless respond_to?("#{k}=")
        send("#{k}=", v)
      end
    end

    def to_hash
      attrs = {}
      public_methods
        .select { |m| m =~ /\w\=$/ }
        .select { |m| respond_to?(m.to_s.chop) }
        .collect { |m| m.to_s.chop.to_sym }
        .each do |item| attrs[item[0]] = item[1] end
      attrs
    end
  end
end