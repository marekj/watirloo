require File.dirname(__FILE__) + '/spec_helper'

require 'observer'

module Watirloo

  # InternetExplorer Object DWebBrowserEvents2 is an Interface for Events.
  # We can hook into the events and intercept the events we care to catch.
  # Every time an event we care to watch for occurs the Publisher notifies observers.
  # Extra: you can also build a publisher that listenes to 'HTMLDocumentEvents2' of ie.ie.document object
  # and notify listeners to onclick events if you need to
  # @events_to_publish = %w[BeforeNavigate2 DocumentComplete NavigateError NewWindow3]
  class BrowserEventsPublisher

    include Observable

    def initialize( ie )
      @events_to_publish = %w[BeforeNavigate2 DocumentComplete TitleChange NavigateError NewWindow3 OnQuit]
      @event_sink = WIN32OLE_EVENT.new( ie.ie, 'DWebBrowserEvents2' )
    end

    def run
      @events_to_publish.each do |event_name|
        @event_sink.on_event(event_name) do |*args|
          changed
          notify_observers( event_name )
        end
        loop { WIN32OLE_EVENT.message_loop }
      end
    end
    
  end

  # Generic Observer of BrowserEventsPublisher.
  # implements update method of an observer to be notified by publisher of events
  class BrowserEventsListener
    attr_accessor :events
    
    def initialize( events_publisher )
      events_publisher.add_observer self
      @events = []
    end

    def update event_name
      puts "#{Time.now}: #{event_name}"
      @events << event_name
    end
  end
end




@ie = Watirloo.browser
events = Thread.start do
  @publisher = Watirloo::BrowserEventsPublisher.new(@ie)
  @publisher.run
end

@listener = Watirloo::BrowserEventsListener.new(@publisher)

puts "pub starter"
puts @listener.events.inspect

@ie.goto "http://yahoo.com/"
puts @listener.events.inspect

#sleep 60
@ie.goto "http://yahoo.com/"
puts @listener.events.inspect

#at_exit do
Thread.kill events
#end

#sleep 5
