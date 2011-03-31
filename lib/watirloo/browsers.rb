module Watirloo

  # This is 'opinionated' method.
  # The way I work with browsers is this:
  # I save the current handle of the browser (ie.hwnd) to the storage yaml file so I can reattach to the same
  # browser later. Basically in exploratory testing I don't want to start and close browsers. I want to maintain
  # reference to one (or more) browsers and I have nicknames for them.
  # on restart of tests I reuse the browser. If the browser is not there I just start a new browser which
  # will from now on become my new 'default' test session browser.
  # In Case of Firefox I attach to the 'one' existing firefox or a start a new one.
  # So this method either attaches to one that's there or it starts a new one and puts it in Browsers::Storage
  # this way of working with browsers is opinionated I think.
  # if you want you can just use Watir::IE.start and reuse that browsers for tests. This here is a convenience method
  def self.browser(key = 'default')
    case Browsers.target
    when :ie then Browsers.ie key
    when :firefox then Browsers.ff
    end
  end

  # manage references to browsers. Currently IE or Firefox.
  # Safari? Other Browser? not yet
  module Browsers

    @@target = :ie #by default we talk to IE on Windows.
    @@targets = [:ie, :firefox]

    class << self

      # set and get the target. by default we talk to :ie.
      def target
        return @@target
      end

      def target=(indicator)
        if @@targets.include? indicator
          @@target = indicator
        else
          raise Exception, "target indicator #{indicator} is not valid: use :ie or :firefox"
        end
      end


      # provides browser instance to client.
      # attaches to the existing 'default' test session browser on the desktop
      # By convention the mental model here is that we are working
      # with one browser on the desktop. This is how a person would typically work
      def ie(key='default')
        begin
          Locker.browser key
        rescue #XXX it's probably a bad practice to use exception for logic control
          # TODO logger here
          ie = Watir::IE.start
          sleep 3
          Locker.add(ie, key)
          ie #return newly created browser for the test session and store it for later usage
        end
      end

      def ff
        require 'watirloo/extension/firewatir_ducktape'
        # this is a cruch for quick work with pages.
        # in reality you want to create a browser and pass it as argument to initialize Page class
        floc = FireLocker.instance
        begin
          floc.browser.url
          floc.browser
        rescue
          floc.clear
          ::FireWatir::Firefox.new
          sleep 2
          floc.browser
        end
      end
    end
  end
end