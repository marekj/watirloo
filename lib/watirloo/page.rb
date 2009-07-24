module Watirloo

  # Semantic Page Objects Container
  # include it in your ClientClass that manages Test. Your client class must provide an instance of browser.
  # If you don't want an explicit browser the Watirloo.browser will be used.
  # example
  #     class UsageScenarioOfSomeFeature
  #       include Watirloo::Page
  #     end
  # now the client GoogleSearch can access browser and elements defined
  # instead of including it directly in classes that you instantiate to keep track of state you can build modules of pages
  # that you can later include into your client
  module Page

    # provides access to the browser for a client
    def browser
      ::Watirloo.browser
    end

    # container that delimits the scope of elements.
    # in a frameless DOM the browser is the doc
    # however if page with frames you can setup a doc destination to be a frame as the
    # base container for face accessors
    def doc
      browser
    end

    module ClassMethods

      # "anything which is the forward or world facing part of a system
      # which has internal structure is considered its 'face', like the facade of a building"
      # ~  http://en.wikipedia.org/wiki/Face
      #
      # Declares Semantic Interface to the DOM elements on the Page (facade) binds a symbol to a block of code that accesses the DOM.
      # When the user speaks of filling in the last name the are usually entering data in a text_field
      # we can create a semantic accessor interface like this:
      #   face(:last_name) {doc.text_field(:name, 'last_nm'}
      # what matters to the user is on the left (:last_name) and what matters to the programmer is on the right
      # The face method provides an adapter and insolates the tests form the changes in GUI.
      #   face(:friendlyname) { watircode } where watircode is actuall way of accessing the element on the page.
      # Each interface or face is an object of interest that we want to access by its interface name
      #   example:
      #
      #     class GoogleSearch
      #       include Watirloo::Page
      #       face(:query)   { doc.text_field(:name, 'q') }
      #       face(:search)  { doc.button(:name, 'btnG') }
      #     end
      #
      def face(name, *args, &definition)
        module_eval do
          define_method(name) do |*args|
            instance_exec(*args, &definition)
          end
        end
      end
    end

    # metahook by which ClassMethods become singleton methods of an including module
    # Perhaps the proper way is to do this
    # class SomeClass
    #   include PageHelper
    #   extend PageHelper::ClassMethods
    # end
    # but we are just learning this metaprogramming
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    # enter values on controls idenfied by keys on the page.
    # data map is a hash, key represents the page objects that can be filled or set with values,
    # value represents its value to be set, either text, array or boolean
    # exmaple: 
    #     spray :first => "Johnny", :last => 'Begood'
    #     
    #     # Given the faces defined
    #     face(:first) {doc.text_field(:name, 'lst_nm')}
    #     face(:last) {doc.text_field(:name, 'fst_nm')}
    def spray(hash)
      hash.each_pair do |facename, value|
        send(facename).set value #make every control element in watir respond to set
      end
    end

    # set values on the page given the interface keys
    alias set spray


    def scrape(field_keys)
      data = {}
      field_keys.each do |k|
        watir_control = send("#{k}")
        method_name = case watir_control.class.to_s.split("::").last
        when "SelectList", "CheckboxGroup", "RadioGroup" then :selected
        else  
          :value
        end
        data.update k => watir_control.send(method_name)
      end
      data
    end


  end
end