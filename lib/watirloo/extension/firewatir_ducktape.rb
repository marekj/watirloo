gem 'firewatir', '>=1.6.2' # dependency
require 'firewatir'

module FireWatir
  
  # duck punch and ducktape Firefox for Watirloo needs
  # some of it is cosmetic surgery and some new methods with intention of
  # sending a patch to Watir maintainers
  class Firefox
    
    # attach to the existing Firefox that was already started with JSSH option.
    # this is a hack for Watirloo. it only attaches to the latest firefox.
    # it assumes there is only one instance of FF window open on the desktop
    def self.attach
      Firefox.new :attach => true
    end
    
    # add option key :attach as a hack
    # :attach => true to attach to topmost window in getWindows().lenght-1
    # split up initialize to conditionally start FireFox
    def initialize(options = {})
      _start_firefox(options) unless options[:attach]
      set_defaults()
      get_window_number()
      set_browser_document()
    end
    
    # refactor initialize method to move all starting of FF into its own method
    def _start_firefox(options)
      if(options.kind_of?(Integer))
        options = {:waitTime => options}
      end
      
      if(options[:profile])
        profile_opt = "-no-remote -P #{options[:profile]}"
      else
        profile_opt = ""
      end
      
      waitTime = options[:waitTime] || 2
      
      case RUBY_PLATFORM 
      when /mswin/
        # Get the path to Firefox.exe using Registry.
        require 'win32/registry.rb'
        path_to_bin = ""
        Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Mozilla\Mozilla Firefox') do |reg|
          keys = reg.keys
          reg1 = Win32::Registry::HKEY_LOCAL_MACHINE.open("SOFTWARE\\Mozilla\\Mozilla Firefox\\#{keys[0]}\\Main")
          reg1.each do |subkey, type, data|
            if(subkey =~ /pathtoexe/i)
              path_to_bin = data
            end
          end
        end
        
      when /linux/i
        path_to_bin = `which firefox`.strip
      when /darwin/i
        path_to_bin = '/Applications/Firefox.app/Contents/MacOS/firefox'
      when /java/
        raise "Not implemented: Create a browser finder in JRuby"
      end
      
      @t = Thread.new { system("#{path_to_bin} -jssh #{profile_opt}")}   
      sleep waitTime
      
    end
    private :_start_firefox

  end

  class SelectList
    
    include Watir::SelectListCommonWatir
    
        # accepts one text item or array of text items. if array then sets one after another. 
    # For single select lists the last item in array wins
    # 
    # examples
    #   select_list.set 'bla' # => single option text
    #   select_list.set ['bla','foo','gugu'] # => set 3 options by text. If 
    #       this is a single select list box it will set each value in turn
    #   select_list set 1 # => set the first option in a list
    #   select_list.set [1,3,5] => set the first, third and fith options
    def set(item)
      _set(:text, item)
    end

    # set item by the option value attribute. if array then set one after anohter.
    # see examples in set method
    def set_value(value)
      _set(:value, value)
    end
    
    # returns array of value attributes
    # each option usually has a value attribute 
    # which is hidden to the person viewing the page
    def values
      a = []
      items.each do |item|
        a << option(:text, item).value
      end
      return a
    end
    
    alias clear clearSelection
    
    # alias, items or contents return the same visible text items
    alias items getAllContents
    
  end

  # RadioGroup and CheckboxGroup common behaviour
  module RadioCheckGroup
    
    include Watir::RadioCheckGroupCommonWatir

    def values
      values = []
      @o.each {|thing| values << thing.value}
      return values
    end
    
    def get_by_value value
      if values.member? value
        @o.find {|thing| thing.value == value}
      else
        raise ::Watir::Exception::WatirException, "value #{value} not found in hidden values"
      end
    end
  end
  
  class CheckboxGroup
    
    include RadioCheckGroup
    include Watir::CheckboxGroupCommonWatir
    
    def initialize(container, name)
      @container = container
      @name = name
      @o = []
      @container.checkboxes.each do |cb| #TODO find why find_all does not work
        if cb.name == @name
          @o << cb
        end
      end
    end
    
    # which values are selected?
    def selected_values
      values = []
      selected_checkboxes.each do |cb|
        values << cb.value
      end
      return values
    end
  end
  
  class RadioGroup
    
    include RadioCheckGroup
    include Watir::RadioGroupCommonWatir
    
    def initialize(container, name)
      @container = container
      @name = name
      @o = []
      @container.radios.each do |r| #TODO find why find_all does not work
        if r.name == @name
          @o << r
        end
      end
      return @o
    end
    
    # see Watir::RadioGroup.selected_value
    def selected_value
      selected_radio.value
    end
    alias selected selected_value
  end
  
  
  module Container
    def radio_group(name)
      RadioGroup.new(self, name)
    end
    
    def checkbox_group(name)
      CheckboxGroup.new(self, name)
    end
  end
end