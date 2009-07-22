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


module Page

  # provides access to the browser for a client
  def browser
    @browser ||= Watirloo.browser
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
    # face method provides an access to some node in the DOM
    # the accessor has a name which has a semantic meaning to the user and it accesses some document object implmementation
    # For example when the user speaks if filling in the last name the are usually entering data in a text_field
    # we can create a semantic accessor like this:
    #   face(:last_name) {doc.text_field(:name, 'last_nm'}
    # what matters to the user is on the left (:last_name) and what matters to the programmer is on the right
    # the face method provides an adapter and insolates the tests form the changes in GUI.
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
end



module MyPage
  include PageHelper
  face(:last_0) { doc.text_field(:name, "last_name0")}

end

module MyPaga
  include PageHelper
  face(:last_1) { doc.text_field(:name, "last_name1")}

end


class BrowserPlayground
  include MyPage
  include MyPaga

  puts "hello from class"
 
end

page = BrowserPlayground.new

#puts page.bla.value
puts page.last_0.value
puts page.last_1.value

exit
#require 'pp'
#pp page.bla
#pp page.last
#
#exit
#
#puts page.last.value
#puts page.last_0.value
#puts page.last_arg(0).value