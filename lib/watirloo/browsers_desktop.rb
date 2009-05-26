module Watirloo
  module Browsers

    # The manager
    # checks to see what browsers already exist on the dekstop.
    # compares what is on the desktop to what is in the storage
    # not really. maybe just take a look at what's on the desktop.
    class Desktop

      class << self
        # returns browsers found on the desktop
        def browsers
          brs =[]
          Watir::IE.each {|ie| brs << ie }
          brs
        end

        def hwnds
          hs =[]
          browsers.each {|ie| hs << ie.hwnd}
          hs
        end

        def additions(known_hwnds)
          hwnds.select {|h| !known_hwnds.include?(h)}
        end

        def deletions(known_hwnds)
          known_hwnds.select {|h| !hwnds.include?(h)}
        end

        def clear
          Watir::IE.each {|ie| ie.close}
          sleep 3
          raise Exception, "Failed to clear all the browsers from the desktop" unless browsers.empty?
        end

      end
    end
  end
end
