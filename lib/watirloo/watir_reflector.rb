=begin rdoc
Look Ma!, I can Has Reflect The Browser

Watir::Reflector module added to watir. 
Run the script to reflect watir elements. reflections create wrapper methods 
with suggested semantic naming based on id, name, value or combination. 
the intention is to create a scaffolding for Watirloo::Page elements.
author: marekj
works with IE class and DOM elements.
=end
module Watir
  
  # Watirloo::Page objects scaffold creation. Talks to the current page and reflects
  # the watir elements to be used for semantic test objects tests.
  module Reflector
    
    @@reflectable_list = [
      :text_fields, 
      :radios, 
      :checkboxes, 
      :select_lists
    ]
    
    #cleanup the def name for some kind of semantic name
    def suggest_def_name(how)
      how.gsub!(/_+/,'_') # double underscores to one
      how.gsub!(/^_/, '') # if it begins with undrscore kill it.
      how.gsub!(/\s+/, '_') # kill spaces if for some strange reason exist
      how = how[0,1].downcase << how[1,how.size] #downcase firs char
    end

    #   glean(:text_fields, [:id, :name, :value]
    #   glean(:radios, [:id, :name, :value])
    # glean and make a map of types and attributes needed for reflection
    # this should be private I think
    def glean(types, attribs)
      result = []
      send(types).each do |el|
        subresult = {}
        attribs.each do |key|
          v = el.attribute_value key.to_s
          subresult.update key => v
        end
        result << subresult
      end
      return result
    end
    
    # example make_reflection(:checkboxes) # => [ defs, setters, faces]
    # returns array of def wrappers, setters for elements and face definitions configs.
    def make_reflection(types)
      attribs = [:id, :name, :value]
      faces = glean(types, attribs)
      watir_method = types.id2name.chop
      if watir_method == 'checkboxe'
        watir_method = 'checkbox' #ooopps ... irregular plural
      end
      def_results = "# #{types.id2name.upcase}: def wrappers with suggested semantic names for elements\n" #holds definition wrappers 
      set_results = "# #{types.id2name.upcase}: setters calling def wrappers with captured values\n" #holds setters with gleaned values
      face_results = "# #{types.id2name.upcase}: face definitions\n" #holds faces 
      
      faces.each do |face|
        id, name, value = face[:id], face[:name], face[:value]
        
        if id != ''
          how, how_s = id, :id
        elsif name != ''
          how, how_s = name, :name
        elsif value != ''
          how, how_s = value, :value
        end
        
        def_name = suggest_def_name(how)
        
        case types
        when :checkboxes, :radios
          extra_value = ", '#{value}'" #for checkboxes and radios
          def_value = "_#{value}" #for checkboxes and radios
          def_results << "\ndef #{def_name}#{def_value}\n\s\s@b.#{watir_method}(:#{how_s}, '#{how}'#{extra_value})\nend\n"
          set_results << "#{def_name}#{def_value}.set\n"
          face_results << ":#{def_name}#{def_value} => [:#{watir_method}, :#{how_s}, '#{how}'#{extra_value}]\n"

        when :select_lists
          # round trip back to browser for items and contents
          value = eval("select_list(:#{how_s}, '#{how}').getSelectedItems")
          items = eval("select_list(:#{how_s}, '#{how}').getAllContents")
          
          def_results << "def #{def_name}\n\s\s@b.select_list(:#{how_s}, '#{how}')\nend\n"
          set_results << "@@#{def_name}_items=#{items.inspect}\n" #class vars for values collections
          set_results << "#{def_name}.set #{value.inspect}\n"
          face_results << "#:#{def_name} => [:select_list, :#{how_s}, '#{name}}']\n"

        else
          def_results << "\ndef #{def_name}#{def_value}\n\s\s@b.#{watir_method}(:#{how_s}, '#{how}'#{extra_value})\nend\n"
          set_results << "#{def_name}#{def_value}.set\n"
          face_results << "\n#:#{def_name}#{def_value} = [:#{watir_method}, :#{how_s}, '#{how}#{extra_value}']\n"

        end

      end
      
      return [def_results, set_results, face_results]
    end
    private :suggest_def_name, :glean, :make_reflection

    # public interface for Reflector. 
    # ie.reflect(:all) # => returns object definitions for entire dom using ie as container
    # ie.frame('main').reflect(:select_lists) # => returns definitions for select_lists only contained by the frame
    # ie.div(:id, 'main').div(:id, 'content').reflect(:all) # => definitions for all supported elements contained by a div 'content' inside div 'main'
    # you can be as granular as needed
    def reflect(watir_types=:all)
      results = []
      case watir_types
      when :all
        @@reflectable_list.each do |types|
          results << make_reflection(types)
        end
      else
        unless @@reflectable_list.include?(watir_types)
          raise ArgumentError, "reflect method does not respond to this argument: #{watir_method}" 
        end
        results << make_reflection(watir_types)
      end
      return results
    end
  end

  # ducktape IE container and include the Reflector.
  class IE
    include Reflector
  end
  
  module Container
    include Reflector
  end
  
end
