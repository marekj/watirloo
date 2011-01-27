
# http://blog.jayfields.com/2006/09/ruby-instanceexec-aka-instanceeval.html # hints on usage
# http://blog.jayfields.com/2008/02/ruby-dynamically-define-method.html # write up on usage
# http://eigenclass.org/hiki.rb?instance_exec # more study
# http://eigenclass.org/hiki.rb?bounded+space+instance_exec # fix for mem leak final used here
# http://eigenclass.org/hiki.rb?Changes+in+Ruby+1.9#l23
# http://www.jroller.com/abstractScope/entry/passing_parameters_to_an_instance
# instance_exec is used for face methods it allows you to pass args and block to be evaled.
# it works like instance eval but instance eval does not accept arguments
if RUBY_VERSION <= '1.8.6'
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
