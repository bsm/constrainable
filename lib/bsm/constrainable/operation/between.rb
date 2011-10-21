module Bsm::Constrainable::Operation
  class Between < Base

    def parsed
      result = case value
      when Range
        [value.first, value.last]
      when /^ *(.+?) *\.{2,} *(.+?) *$/
        [$1, $2]
      else
        value
      end
      result.is_a?(Array) && result.size == 2 ? result.map(&:to_s) : nil
    end

    protected

      def _clause
        attribute.gteq(normalized.first).and(attribute.lteq(normalized.last))
      end

  end
end
