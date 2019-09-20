# frozen_string_literal: true

module ThemePark
  class CLI
    class Render
      def call(element)
        case element
        when String
          puts element
        when Array
          element.map do |child|
            call(child)
          end
        when Components::Component
          call(element.render)
        when Proc
          element.call
        when nil
          nil
        else
          raise ArgumentError, "Unknown element: #{element.inspect}"
        end
      end
    end
  end
end
