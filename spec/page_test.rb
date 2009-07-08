require File.dirname(__FILE__) + '/spec_helper'

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


class BrowserPlayground
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

  def self.define(hash)
    method_name = hash.keys[0]
    watir_element, how, what = hash.values[0]
    class_eval "def #{method_name}(*args)
        browser.#{watir_element}(:#{how}, \"#{what}\")
      end"
    
  end


  define :bla => [:text_field, :name, "last_name0"]

  # what does this form buy me? hmm...
  face(:last_0) { browser.text_field(:name, "last_name0") }

  # this form allows me to set up arg to alter name in a collection by number
  face(:last_arg) { |i| browser.text_field(:name, "last_name#{i}") }



  # this is a simple form as def with default provided
  def last(cc="0")
    browser.text_field(:name, "last_name#{cc}")
  end

end

#page = BrowserPlayground.new
#puts page.bla
#puts page.last

#exit
#require 'pp'
#pp page.bla
#pp page.last
#
#exit
#
#puts page.last.value
#puts page.last_0.value
#puts page.last_arg(0).value


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