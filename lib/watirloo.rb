$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'watirloo/watir_ducktape'
require 'watirloo/reflector'

module Watirloo

  VERSION = '0.0.2' # Jan2009
  
  # browser. we return IE or Firefox. Safari? Other Browser?
  class BrowserHerd 
    
    @@target = :ie #default target

    def self.target=(indicator)
      @@target = indicator
    end
    
    def self.target
      @@target
    end
    
    #provide browser
    def self.browser
      case @@target
      when :ie 
        Watir::IE.attach :url, // #this attach is a crutch
      when :firefox
        require 'watirloo/firewatir_ducktape'
        # this is a cruch for quick work with pages.
        # in reality you want to create a browser and pass it as argument to initialize Page class
        FireWatir::Firefox.attach #this attach is a crutch
      end
    end
  end
  
  # Semantic Page Objects Container.
  # page objects are defined as faces of a Page.
  # Each face (aka Interface of a page) is accessed by page.facename or page.face(:facename) methods
  # Pages make Watir fun
  class Page
    
    attr_accessor :browser
    attr_reader :interfaces

    class << self 
      def interfaces
        @interfaces ||= {}
      end
      def set(facename, definition)
        self.interfaces[facename] = definition
      end
    end
    # by convention the Page just attaches to the first available browser.
    # the smart thing to do is to manage browsers existence on the desktop separately
    # and supply Page class with the instance of browser you want for your tests.
    # &block is the convenience at creation time to do some work.
    # example:
    #   browser = Watir::start("http://mysitetotest")
    #   page = Page.new(browser) # specify browser instance to work with or
    #   page = Page.new # just let the page do lazy thing and attach itself to browser.
    # part of this page initialization is to provide a convenience while developing tests where
    # we may have only one browser open and that's the one browser were we want to talk to.
    def initialize(browser = Watirloo::BrowserHerd.browser , &blk)
      @browser = browser
      instance_eval(&blk) if block_given? # allows the shortcut to do some work at page creation
    end
  
    # enter values on controls idenfied by keys on the page.
    # data map is a hash, key represents the page object,
    # value represents its value to be set, either text, array or boolean
    def spray(dataMap)
      dataMap.each_pair do |label, value|
        #depends on every element in the dom to respond 
        #to set method in order to set value
        interface(label).set value 
      end
    end
    
    # set values on the page given the interface keys
    alias set spray 
  
    # return Watir object given by its semantic interface symbol name
    def interface(face_symbol)
      #if there is a defined wrapper method for page element provided
      if self.respond_to? face_symbol 
        return self.send(face_symbol) 
      # or pull element from @interfaces and send to browser
      elsif @interfaces.member?(face_symbol) 
        method, *args = @interfaces[face_symbol]
        # return definition for face consumable by browser
        return @browser.send(method, *args)
      else
        raise ::Watir::Exception::WatirException, "Interface not defined for this page: #{face_symbol}"
      end
    end
  
    # add face definition to page
    def add_interface(face_and_value)
      if definitions.kind_of?(Hash)
        @interfaces.update face_and_value
      else
        raise ::Watir::Exception::WatirException, "Interface requires key as label and value as browser definition"
      end
    end
  
    # 
    def method_missing method, *args
      if @browser.respond_to? method
        @browser.send method, *args
      elsif  @interfaces.member?(method.to_sym)
        get_interface(method.to_sym)
      else
        raise ::Watir::Exception::WatirException, 'I ran out of ideas in Watirloo'
      end
    end
  end

end