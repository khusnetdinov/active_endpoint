module Coercoable
  class ::Numeric
    def days
      ::ActiveSupport::Duration.new(24.hours * self, [[:days, self]])
    end
    alias :day :days

    def weeks
      ::ActiveSupport::Duration.new(7.days * self, [[:days, self * 7]])
    end
    alias :week :weeks

    def fortnights
      ::ActiveSupport::Duration.new(2.weeks * self, [[:days, self * 14]])
    end
    alias :fortnight :fortnights
  end

  class ::Integer
    def months
      ::ActiveSupport::Duration.new(30.days * self, [[:months, self]])
    end
    alias :month :months

    def years
      ::ActiveSupport::Duration.new(365.25.days * self, [[:years, self]])
    end
    alias :year :years
  end
end
