module Watirloo


  # manages references to browsers we care about to run tests agains.
  # Saves references to window handles internall to yaml file so we can reuse the browser for tests by reattaching to it between tests.
  # you put reference to a browser in storage. Next time you run a test you can restore the browser's reference instead fo staring a new one.
  module Locker

    @@locker_file = File.join(File.dirname(__FILE__), "..", "..", "log", "locker.yml")

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
          (@browser && @browser.exists?) ? @browser : @browser = attach_browser
        else
          attach_browser(key)
        end
      end

      # add browser to storage for later reuse. by convention if you don't have any browsers it
      # so you can later restore it and continue working with it.
      # pass either browser referene or the hwnd Fixnum
      def add(browser, key='default')
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
          loaded = YAML::load_file(locker)
          #if file is empty or not well formed yaml
          #or not a hash then return empty hash
          loaded.kind_of?(Hash) ? loaded : {}
        else
          #empty hash if locker.yaml not there
          #or malformed loaded not created yet
          {} 
        end
      end

      def save_mapping
        File.open(locker,'w') {|f| YAML.dump(mapping, f)}
      end

      # throws exception if can't attach to the known handle. 
      def attach_browser(key='default')
        Watir::IE.attach(:hwnd, mapping[key])
      end

    end
  end
end
