module Watirday
  module JustTextNotExecutableCode


    # Move to later
    # verification
    page = PersonPage.new browser
    page.firstname.value.should == 'Franz'
    page.lastname.value.should == 'Ferdinand'
    page.gender.selected_option.should == 'M'


    # Domain Specific Page Object

    # def user_value #secret decoder ring
    # what's coming from Watir Object to your Domain Specific Language
    # String, Boolean, Array


# month, day, year selector
    class DateSelector

      def initialize(prefix, container)
        @container = container
        @month = @container.select_list(:id, prefix + '_MONTH')
        @day = @container.select_list(:id, prefix + '_DAY')
        @year = @container.select_list(:id, prefix + '_YEAR')
      end

    end

# hour, minute, ampm selector
    class TimeSelector

      def initialize(prefix, container)
        @container = container
        @hour = @container.select_list(:id, prefix + '_HOUR12')
        @minute = @container.select_list(:id, prefix + '_MINUTE')
        @ampm = @container.select_list(:id, prefix + '_AMPM')
      end

      def set value
        str = value.respond_to?(:strftime) ? x.strftime("%I:%M %p") : value
        time, ampm = str.split(' ')
        hour, minute = time.split(':')
        @hour.set hour if hour
        @minute.set minute if minute
        @ampm.set (@ampm.options.find { |t| t =~ /#{ampm}/i } || ampm) if ampm
      end
    end


# DateSelector and TimeSelector
    class DateTimeSelector

      def initialize(prefix, container)
        @container = container
        @date = DateSelector prefix, container
        @time = TimeSelector prefix, container
      end

      def set value
        @date.set value
        @time.set value
      end

    end

    class CheckboxDateTimeSelector

      def initialize(checkbox, prefix, container)
        @checkbox = checkbox
        @selector = DateTimeSelector.new prefix, container
      end

      def user_value
        @checkbox.set? ? @selector.value : false
      end

      def set?
        @checkbox.set?
      end
    end

  end
end


