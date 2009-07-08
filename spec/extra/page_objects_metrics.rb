# see this;http://blog.jayfields.com/2008/02/ruby-dynamically-define-method.html
if VERSION <= '1.8.6'
  class Object
    module InstanceExecHelper; end
    include InstanceExecHelper
    # instance_exec method evaluates a block of code relative to the specified object, with parameters whom come from outside the object.
    def instance_exec(*args, &block)
      begin
        old_critical, Thread.critical = Thread.critical, true
        n = 0
        n += 1 while respond_to?(mname="__instance_exec#{n}")
        InstanceExecHelper.module_eval{ define_method(mname, &block) }
      ensure
        Thread.critical = old_critical
      end
      begin
        ret = send(mname, *args)
      ensure
        InstanceExecHelper.module_eval{ remove_method(mname) } rescue nil
      end
      ret
    end
  end
end

# Need to rethink this page adapter idea
# I can make shortcuts to page elements with either blocks or defs or some hashmaps.
# def is the easiest most versitile I think
#
# what does it buy me to have this mechanism for defining pageobjects?
# pageobject(:name) {browser.text_field(:name, 'somename')}
# The way someone works with tests is they will define code like this
# browser.text_field(:name, 'somename')
# Then you can wrap it as a proc and tag it with a name as above.
# on the other hand how about storing access to objects in yaml files?
#
# ---
# :bla:
# - :text_field
# - :name
# - bla
#
# ---
# object_name: bla
# - :text_field
# - :name
# - bla

#
#

require 'benchmark'
result = Benchmark.bmbm do |test|

  test.report('class eval block') do
    class PageByClassEval
      def self.face(name, *args, &definition)
        class_eval do
          define_method(name) do |*args|
            instance_exec(*args, &definition)
          end
        end
      end
      def browser
        Watirloo.browser
      end
      face(:last_0) { browser.text_field(:name, "last_name0") }
      #face(:last_arg) { |i| browser.text_field(:name, "last_name#{i}") }
    end
    10000.times do
      page = PageByClassEval.new
      page.last_0.value
      #page.last_arg(0).value
    end
  end

  test.report('regular def') do
    class PageByDef
      def browser
        Watirloo.browser
      end
      def last(cc="0")
        browser.text_field(:name, "last_name#{cc}")
      end
    end
    10000.times do
      page = PageByDef.new
      page.last.value
      #page.last(0).value
    end
  end


  test.report('class eval string') do
    class PageByClassEvalString
      def browser
        Watirloo.browser
      end
      def self.face(hash)
        method_name = hash.keys[0]
        watir_element, how, what = hash.values[0]
        class_eval "def #{method_name}
                        browser.#{watir_element}(:#{how}, \"#{what}\")
                    end"

      end
      face :last => [:text_field, :name, "last_name0"]
    end
    10000.times do
      page = PageByClassEvalString.new
      page.last.value
    end
  end



end


puts total = result.inject(0.0) { |mem, bm| mem + bm.real }
puts "total : " + total.to_s
puts "average: " + (total/result.size.to_f).to_s

=begin
Rehearsal -----------------------------------------------------
class eval block    4.344000   1.656000   6.000000 ( 14.656000)
regular def         3.781000   1.625000   5.406000 ( 13.344000)
class eval string   3.500000   1.531000   5.031000 ( 13.375000)
------------------------------------------- total: 16.437000sec

                        user     system      total        real
class eval block    4.422000   1.406000   5.828000 ( 13.953000)
regular def         3.313000   1.485000   4.798000 ( 13.344000)
class eval string   3.875000   1.171000   5.046000 ( 13.328000)
40.6250002384186
total : 40.6250002384186
average: 13.5416667461395

=end