$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'watirloo/watir_ducktape'
require 'watirloo/reflector'

module Watirloo

  VERSION = '0.0.2' # Jan2009
  
  # Generic Semantic Test Object
  module TestObject
    attr_accessor :id, :desc
  
  end

  # browser. we return IE or Firefox. Safari? Other Browser?
  class BrowserHerd 
    include TestObject
    
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
    
    include TestObject
    attr_accessor :b #browser
    attr_reader :interfaces

    class << self
      def interfaces
        @interfaces ||= {} #hash key value pairs, key is facename you refer to value is suitcase you carry to open later
      end
      # declare interface to things on the page
      # each thing is an object of interest that we want to access by its interface name
      # each thing is a package of block of code as a suitcase and a label 
      # pointing to the block in suitcase
      # this is nice code pattern borrowed from taza
      # at first I thought of doing just simply interfaces.update key => value
      # but making a mehtod is nicer plus all interfaces will need blocks.
      def interface(label, &suitcase)
        self.interfaces[label] = suitcase #make hash
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
    # this provides simplicity for those who are just starting with Watirloo
    def initialize(browser = Watirloo::BrowserHerd.browser , &blk)
      @b = browser
      create_interfaces
      instance_eval(blk) if block_given? # allows the shortcut to do some work at page creation
    end
    
    def create_interfaces
      self.class.interfaces.each do |label, suitcase|
        #self.class.send(:define_method, label, suitcase)
        define_method label do 
          @b.suitcase
        end
      end
    end
    
    # enter values on controls idenfied by keys on the page.
    # data map is a hash, key represents the page object,
    # value represents its value to be set, either text, array or boolean
    def spray(dataMap)
      dataMap.each_pair do |face_symbol, value|
        get_face(face_symbol).set value #make every element in the dom respond to set to set its value
      end
    end
  
    # return Watir object given by its semantic face symbol name
    def get_face(face_symbol)
      if self.respond_to? face_symbol # if there is a defined wrapper method for page element provided
        return self.send(face_symbol) 
      elsif @faces.member?(face_symbol) # pull element from @faces and send to browser
        method, *args = @faces[face_symbol] # return definition for face consumable by browser
        return @b.send(method, *args)
      else
        #??? I ran out of ideas
        raise ::Watir::Exception::WatirException, 'I ran out of ideas in Watirloo'
      end
    end
    alias face get_face
  
    # add face definition to page
    def add_face(definitions)
      if definitions.kind_of?(Hash)
        @faces.update definitions  
      end
    end
  
    # Delegate execution to browser if no method or face defined on page class
    def method_missing method, *args
      if @b.respond_to? method
        @b.send method, *args
      elsif  @faces.member?(method.to_sym)
        get_face(method.to_sym)
      else
        raise ::Watir::Exception::WatirException, 'I ran out of ideas in Watirloo'
      end
    end
  end

end