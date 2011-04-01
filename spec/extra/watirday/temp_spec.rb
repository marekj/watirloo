module Watirday
  module JustTextNotExecutableCode


    # month, day, year selector
    class DateSelector

      def initialize(prefix)
        @month = Page.browser.select_list(:id, prefix + '_MONTH')
        @day = Page.browser.select_list(:id, prefix + '_DAY')
        @year = Page.browser.select_list(:id, prefix + '_YEAR')
      end

      def value             #turns Apr to 04
        sprintf("%s/%s/%s", month_to_int, @day.value, @year.value)
      end
    end

    class PublishPage < Page
      def scheduledon
        DateSelector.new 'publish'
      end
    end

    page = PublishPage.new
    page.set :scheduledon => '04/02/2011'

    # hour, minute, ampm selector
    class TimeSelector

      def initialize prefix
        @hour = Page.browser.select_list(:id, prefix + '_HOUR12')
        @minute = Page.browser.select_list(:id, prefix + '_MINUTE')
        @ampm = Page.browser.select_list(:id, prefix + '_AMPM')
      end

      def value=(x)
        str = value.respond_to?(:strftime) ? x.strftime("%I:%M %p") : value
        time, ampm = str.split(' ')
        hour, minute = time.split(':')
        @hour.set hour if hour
        @minute.set minute if minute
        @ampm.set (@ampm.options.find { |t| t =~ /#{ampm}/i } || ampm) if ampm
      end
    end


    # DateSelector and TimeSelector as One
    class DateTimeSelector

      def initialize(prefix)
        @date = DateSelector.new prefix
        @time = TimeSelector.new prefix
      end

    end

    class PublishPage
      def scheduler
        DateTimeSelector.new 'publish'
      end
    end

    page = PublishPage.new
    # specific date and time publish
    page.set :scheduler => '04/02/2011 11:30 am'

    class CheckboxDateTimeSelector

      def initialize(checkbox, prefix)
        @checkbox = checkbox
        @selector = DateTimeSelector.new prefix
      end

      def value=(x)
        if x == false
          @checkbox.set false
        elsif x == true
          @checkbox.set
        elsif x.kind_of?(String)
          @checkbox.set
          @selector.value = x
        end
      end

      def value
        @checkbox.set? ? @selector.value : false
      end
    end

    class PublishPage
      def checkbox
        browser.checkbox(:id, 'publish_enabler')
      end

      def scheduler
        CheckboxDateTimeSelector.new checkbox, 'publish'
      end
    end

    page = PublishPage.new
    # turns off publish schedule
    page.set :scheduler => false
    # turns it on with default datetime
    page.set :scheduler => true
    # specific datetime
    page.set :schduler => '04/02/2011 11:30 am'

  end
end


