=begin rdoc
Look Ma!, I can Has Reflect The Browser

Watir::Reflector module added to watir. 
reflect watir element collections. reflections create wrapper methods 
with suggested semantic naming based on id, name, value or combination. 
the intention is to create a scaffolding for Watirloo::Page elements.
=end

module Watir
  
  # Watirloo::Page objects scaffold creation. Talks to the current page and reflects
  # the watir elements to be used for semantic test objects tests.
  module Reflector
    
    #cleanup the def name for some kind of semantic name
    def suggest_def_name(how)
      how.gsub!(/_+/,'_') # double underscores to one
      how.gsub!(/^_/, '') # if it begins with undrscore kill it.
      how.gsub!(/\s+/, '_') # kill spaces if for some strange reason they exist
      how.underscore #Any CamelCase will be converted to camel_no_case
    end

    # glean(:text_fields, [:id, :name, :value]
    # glean(:radios, [:id, :name, :value])
    # glean and make a map of types and attributes needed for reflection
    # this should be private I think
    def get_attribs(item)
      attribs = [:id, :name, :value]
      h = {}
      attribs.each do |k|
        v = item.attribute_value k.to_s
        h[k] = v
      end
      h
    end
    
    def get_how_what h
      how, what = '', ''
      if h[:id] != '' #First Choice: if id is not blank then we'll use it
        how, what = :id, h[:id]
      elsif h[:name] != '' #Second Choice: if name is not blank then we'll use it instead of id
        how, what = :name, h[:name]
      elsif h[:value] != ''
        how, what = :value, h[:value]
      end
      [how, what]
    end
    
    # public interface for Reflector.
    # ie.reflect # => returns object definitions for entire dom using ie as container
    # ie.frame('main').select_lists.reflect# => returns definitions for select_lists 
    # only contained by the frame
    # you can be as granular as needed
    def reflect
      puts "I has not exist. Implements me please"
    end
  end
  
  
  module Container

    # container asks collections to reflect themselves
    # each collection knows how to reflect itself and what to reflect
    def reflect
      ref = []
      [:radio_groups, :checkbox_groups, :text_fields, :select_lists].each do |type|
        ret << self.send(type).reflect
      end
      return ref
    end

  end


  class ElementCollections

    # adds reflect method to element collections
    include ::Watir::Reflector

  end

end
