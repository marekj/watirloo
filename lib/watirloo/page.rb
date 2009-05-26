module Watirloo

  # Semantic Page Objects Container
  # Page containes interfaces to Objects of Interest on the Web Page
  # Each object defined by key, value pair,
  # Keys is a friendly name, recognizable name given by the domain object model.
  # Some name that is meaningful to the customer.
  # The value of the interface definiton is a Watir object address in the dom container.
  # The Page class acts as an Adapter between the Business Domain naming of things and Document Object Model naming of elments.
  # It strives to adapt Human Readable tests to Machine Executable code
  class Page

    ## Page Eigenclass
    class << self

      # hash key value pairs,
      # each interface definition is a key as symbol pointing to some code to
      # exeucte later.
      def interfaces
        @interfaces ||= {}
      end

      # Declares Semantic Interface to the DOM elements on the Page
      #   face :friendlyname => [watirelement, how, what]
      # Each interface or face is an object of interest that we want to access by its interface name
      # example:
      #   class GoogleSearch < Watirloo::Page
      #     face :query => [:text_field, :name, 'q]
      #     face :search => [:button, :name, 'btnG']
      #  end
      # each face is a key declared by a semantic symbol that has human meaning in the context of a usecase
      # each value is an array defining access to Watir [:elementType, how, what]
      def interface(definition)
        if definition.kind_of? Hash
          self.interfaces.update definition
        else
          raise ::Watir::Exception::WatirException, "Wrong arguments for Page Object definition"
        end
      end
      alias face interface

      def inherited(subpage)
        #puts "#{subpage} inherited #{interfaces.inspect} from #{self}"
        subpage.interfaces.update self.interfaces #supply parent's interfaces to subclasses in eigenclass
      end
    end

    attr_accessor :b, :interfaces

    def browser
      @b
    end


    def create_interfaces
      @interfaces = self.class.interfaces.dup # do not pass reference, only values
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
    def initialize(browser = Watirloo.browser , &blk)
      @b = browser
      create_interfaces
      yield browser if block_given? # allows the shortcut to do some work at page creation
    end


    # enter values on controls idenfied by keys on the page.
    # data map is a hash, key represents the page object,
    # value represents its value to be set, either text, array or boolean
    def spray(dataMap)
      dataMap.each_pair do |facename, value|
        get_face(facename).set value #make every element in the dom respond to set to set its value
      end
    end

    # set values on the page given the interface keys
    alias set spray

    # return Watir object given by its semantic face symbol name
    def get_face(facename)
      if self.respond_to? facename # if there is a defined wrapper method for page element provided
        return self.send(facename)
      elsif interfaces.member?(facename) # pull element from @interfaces and send to browser
        method, *args = self.interfaces[facename] # return definition for face consumable by browser
        return browser.send(method, *args) #returns Watir Element class
      else
        raise ::Watir::Exception::WatirException, 'Unknown Semantic Facename'
      end
    end

    # add face definition to page
    def interface(definitions)
      if definitions.kind_of?(Hash)
        interfaces.update definitions
      else
        raise ::Watir::Exception::WatirException, "Wrong arguments for Page Object definition"
      end
    end
    alias face interface

    # Delegate execution to browser if no method or face defined on page class
    def method_missing method, *args
      if browser.respond_to?(method.to_sym)
        return browser.send(method.to_sym, *args)
      elsif  interfaces.member?(method.to_sym)
        return get_face(method.to_sym)
      else
        raise ::Watir::Exception::WatirException, 'I ran out of ideas in Watirloo'
      end
    end
  end
end