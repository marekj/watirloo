module Watirloo


  # manages references to browsers we care about to run tests agains.
  # Saves references to window handles internall to yaml file so we can reuse the browser for tests by reattaching to it between tests.
  # you put reference to a browser in storage. Next time you run a test you can restore the browser's reference instead fo staring a new one.
  module Locker

    @@locker_file = File.join(File.dirname(__FILE__), "..", "..", "config", "locker.yml")

    class << self

      # hash of {key => IE.hwnd} to attach and reuse browsers
      # example: mapping = {:default=> 234567, :bla => 234234}
      def mapping
        @mapping ||= read_mapping
      end

      def locker
        @@locker_file
      end

      def locker=( locker )
        @@locker_file = locker
      end

      # returns IE reference to a browser with a given key
      def browser(key='default')
        if key == 'default'
          @browser ||= attach_browser #reuse default wihtout reattaching
        else
          attach_browser key
        end
      end

      # add browser to storage for later reuse. by convention if you don't have any browsers it
      # so you can later restore it and continue working with it.
      # pass either browser referene or the hwnd Fixnum
      def add(key='default', browser=Watir::IE.start)
        mapping[key] = browser.kind_of?(Watir::IE) ? browser.hwnd : browser
        save_mapping
      end

      # remove browser from storage and from further reusing
      def remove(key='default')
        @browser = nil if key == 'default'
        mapping.delete(key) if mapping[key]
        save_mapping
      end

      # clear Storage
      def clear
        @browser = nil
        mapping.clear
        save_mapping
      end

      private

      def read_mapping
        if FileTest.exists?(locker)
          YAML::load_file(locker)
        else
          {} #empty hash if stores not created yet
        end
      end

      def save_mapping
        File.open(locker,'w') {|f| YAML.dump(mapping, f)}
      end

      def attach_browser(key='default')
        Watir::IE.attach(:hwnd, mapping[key])
      end

    end
  end
end
