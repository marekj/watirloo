module Watirloo

  # The browser desktop manager
  # checks to see what browsers already exist on the dekstop.
  # compares what is on the desktop to what was there last time
  module Desktop

    class << self

      # returns browser windows found on the desktop
      def browsers
        brs =[]
        Watir::IE.each {|ie| brs << ie }
        brs
      end

      # return handles of Browsers found on desktop
      def hwnds
        hs =[]
        browsers.each {|ie| hs << ie.hwnd}
        hs
      end

      # returns handles for browsers that appeared on Desktop since the last scan for browsers
      def additions(known_hwnds)
        hwnds.select {|h| !known_hwnds.include?(h)}
      end

      # returns handles for browsers no longer found on the Desktop since the last scan for browsers
      def deletions(known_hwnds)
        known_hwnds.select {|h| !hwnds.include?(h)}
      end

      # Closes all the browsers on the desktop.
      # Creats a known clear slate where no browsers exist
      def clear
        browsers.each {|ie| ie.close; sleep 3}
        sleep 3
        raise Exception, "Failed to clear all the browsers from the desktop" unless browsers.empty?
      end

    end
  end
end
