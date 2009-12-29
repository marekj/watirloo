require 'firewatir'

module FireWatir
    
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
    def select( item )
      _set(:text, item)
    end

    # set item by the option value attribute. if array then set one after anohter.
    # see examples in set method
    def select_value( value )
      _set(:value, value)
    end

    # set :value or :text
    def _set(how, what)
      if what.kind_of? Array
        what.each { |item| _set(how,item)} # call self with individual item
      else
        if what.kind_of? Fixnum # if by position then translate to set by text
          if (0..items.size).member? what
            _set :text, items[what-1] #call self with found item
          else
            raise ::Watir::Exception::WatirException, "number #{item} is out of range of item count"
          end
        else
          select_items_in_select_list(how, what)  #finally as :value or :text
        end
      end

    end
    alias set select
    alias set_value select_value
    
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

    def name
      @name
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

  class CheckboxGroups < ElementCollections
    #   def element_class; CheckboxGroup; end

    def initialize(container)
      @container = container
      elements = locate_elements
      @element_objects = []
      # for each unique name create a checkbox_group
      elements.each do |name|
        @element_objects << CheckboxGroup.new(container, name)
      end
    end

    def length
      @element_objects.size
    end

    # return array of unique names for checkboxes in container
    def locate_elements
      names = []
      @container.checkboxes.each do |cb|
        names << cb.name
      end
      names.uniq #non repeating names
    end


    # allows access to a specific item in the collection. 1-based index
    def [](n)
      @element_objects[n-1]
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