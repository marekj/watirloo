module Watirloo

  # Semantic Page Objects Container
  # include it in your ClientClass that manages Test. Your client class must provide an instance of browser.
  # If you don't want an explicit browser the Watirloo.browser will be used.
  # example
  #     class MyFieldsPage
  #       include Watirloo::Page
  #     end
  # now the client MyFieldsPage can access browser and field elements defined
  # instead of including it directly in classes that you instantiate to keep track of state you can build modules of pages
  # that you can later include into your client
  module Page

    # provides browser for your page
    # defaults to Watirloo.browser
    def browser
      @browser ||= ::Watirloo.browser
    end

    # sets browser for a page
    def browser=(browser)
      @browser = browser
    end

    # browser document container that delimits the scope of field elements
    # all fields use page as a base. In a frameless DOM the browser is page, the document container.
    # however if page with frames you can setup a doc destination to be a frame as the
    # base container for field accessors.
    # in most circumstances page is a passthru to browser
    # example: if you have a frameset and you want to talk to a frame(:name, 'content') you can redefine
    # page = browser.frame(:name, 'content')
    #
    def page
      @page ||= browser
    end

    # set the page container element as the receiver of all field methods
    def page=(watir_element)
      @page = watir_element
    end

    module ClassMethods

      # "anything which is the forward or world facing part of a system
      # which has internal structure is considered its 'field', like the facade of a building"
      # ~  http://en.wikipedia.org/wiki/Face
      #
      # Declares Semantic Interface to the DOM elements on the Page (facade) binds a symbol to a block of code that accesses the DOM.
      # When the user speaks of filling in the last name the are usually entering data in a text_field
      # we can create a semantic accessor interface like this:
      #   field(:last_name) { text_field(:name, 'last_nm'}
      # what matters to the user is on the left (:last_name) and what matters to the programmer is on the right
      # The field method provides an adapter and insolates the tests form the changes in GUI.
      # The patterns is: field(:friendlyname) { watir_element(how, whatcode }
      # where watir_element is actuall way of accessing the element on the page. The page is implicit.
      # Each interface or field is an object of interest that we want to access by its interface name
      #   example:
      #
      #     class GoogleSearch
      #       include Watirloo::Page
      #       field(:query)   { text_field(:name, 'q') }
      #       field(:search)  { button(:name, 'btnG') }
      #     end
      #
      #     at run time calling
      #     query.set "Ruby"
      #     is equivalent to
      #     page.text_field(:name, 'q').set "Ruby"
      #     where page is the root of HTML document
      #
      def field(name, *args, &definition)
        define_method(name) do |*args|
          page.instance_exec(*args, &definition)
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

    # populate fields with values.
    # data map is a hash, key represents the page objects that can be filled or set with values,
    # value represents its value to be set, either text, array or boolean
    # exmaple: 
    #     populate :firstname => "Johnny", :lastname => 'Begood'
    #     
    #     # Given the fields defined on a page
    #     field(:firstname) {text_field(:name, 'lst_nm')}
    #     field(:lastname) {text_field(:name, 'fst_nm')}
    def populate(hash)
      hash.each_pair do |field, value|
        self.send(field).set value #make every control element in watir respond to set
      end
    end

    # set values on the page given the interface keys
    alias set populate
    alias spray populate

    # pass keys to query for value displayed to the user
    def scrape(fieldnames)
      data = {}
      case fieldnames
        when Symbol
          scrape_field(fieldnames)
        when Array
          fieldnames.each { |field| data.update(scrape_field(field)) }
          data
      end
    end

    def scrape_field(fieldname)
      watir_control = self.send fieldname
      method_name = case watir_control.class.to_s.split("::").last
                      when "SelectList", "CheckboxGroup", "RadioGroup" then
                        :selected
                      else
                        :value
                    end
      {fieldname => watir_control.send(method_name)}
    end
    private :scrape_field


  end
end