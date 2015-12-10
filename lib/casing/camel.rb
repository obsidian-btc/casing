module Casing
  module Camel
    class Error < RuntimeError; end
    def self.call(val, convert_values: nil)
      case val
        when ::Hash
          Hash.(val, convert_values: convert_values)

        when ::Array
          Array.(val, convert_values: convert_values)

        when ::String
          String.(val, convert_values: convert_values)

        when ::Symbol
          String.(val, convert_values: convert_values)

        else
          val
      end
    end
    class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

    def self.assure(val, assure_values: nil)
      assure_values ||= false

      case val
        when ::Array
          val.map { |v| assure(v, assure_values: assure_values) }
        when ::Hash
          val.map { |k, v| assure_camel_case(k); assure(v, assure_values: assure_values) }
        else
          if assure_values
            assure_camel_case(val)
          end

          val
      end
    end

    def self.assure_camel_case(val)
      val.split.each do |v|
        unless v.match /^([a-z]+([A-Z][a-z]+)+)|[a-z]+/
          raise Error, "#{val} is not camel-cased"
        end
      end
    end
  end
end
