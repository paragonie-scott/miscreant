# encoding: binary
# frozen_string_literal: true

module Miscreant
  module Internals
    # Internal utility functions
    module Util # :nodoc:
      module_function

      # Perform a constant time-ish comparison of two bytestrings
      def ct_equal(a, b)
        return false unless a.bytesize == b.bytesize

        l = a.unpack("C*")
        r = 0
        i = -1

        b.each_byte { |v| r |= v ^ l[i += 1] }
        r.zero?
      end

      # Pad value with a 0x80 value and zeroes up to the given length
      def pad(message, length)
        padded_length = message.length + length - (message.length % length)
        message += "\x80"
        message.ljust(padded_length, "\0")
      end

      # Perform a constant time(-ish) branch operation
      def select(subject, result_if_one, result_if_zero)
        (~(subject - 1) & result_if_one) | ((subject - 1) & result_if_zero)
      end

      # Ensure a string is a valid bytestring (potentially of a given length)
      def validate_bytestring(string, length: nil)
        raise TypeError, "expected String, got #{string.class}" unless string.is_a?(String)
        raise ArgumentError, "value must be Encoding::BINARY" unless string.encoding == Encoding::BINARY

        case length
        when Array
          raise ArgumentError, "value must be #{length.join(' or ')} bytes long" unless length.include?(string.bytesize)
        when Integer
          raise ArgumentError, "value must be #{length}-bytes long" unless string.bytesize == length
        else
          raise TypeError, "bad length parameter: #{length.inspect} (#{length.class}" unless length.nil?
        end

        string
      end
    end
  end
end
