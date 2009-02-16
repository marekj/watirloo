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
      how.gsub!(/\s+/, '_') # kill spaces if for some strange reason exist
      how = how[0,1].downcase << how[1,how.size] #downcase firs char
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
      if h[:id] != ''
        how, what = :id, h[:id]
      elsif h[:name] != ''
        how, what = :name, h[:name]
      elsif h[:value] != ''
        how, what = :value, h[:value]
      end
      [how, what]
    end
  
    
    # example make_reflection(:checkboxes) # => [ defs, setters, faces]
    # returns array of def wrappers, setters for elements and face definitions configs.
    def make_reflection(types)
      
      watir_method = types.id2name.chop
      watir_method = 'checkbox' if watir_method == 'checkboxe'#ooopps ... irregular plural
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
          def_results << "def #{def_name}#{def_value}\n\s\s@b.#{watir_method}(:#{how_s}, '#{how}'#{extra_value})\nend\n"
          set_results << "#{def_name}#{def_value}.set\n"
          face_results << ":#{def_name}#{def_value} => [:#{watir_method}, :#{how_s}, '#{how}'#{extra_value}]\n"
          #GROUP
          watir_method = "checkbox_group" if types == :checkboxes 
          watir_method = "radio_group" if types == :radios 
          def_results << "def #{def_name}\n\t\@b.#{watir_method}('#{name}')\n"
          face_results << "face :#{def_name} => [:#{watir_method}, :#{name}]\n"
          
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
      ref  << self.radio_groups.reflect
      ref << self.checkbox_groups.reflect
      ref << self.text_fields.reflect
    end
    
  end
  
end
