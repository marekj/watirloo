module Watirloo

  # UseCase main scenario and behavior
  # it collaborates with Page class to realize scenario.
  # run method executes sequantial methods listed in scenario
  # The UseCase class is my test modeling loosely based on my reading 
  # of "Applying Use Case Driven Object Modeling with UML"
  # by Kendall Scott and Doug Rosenberg.
  # The conceptual model is this: UseCase has a main scenario that realizes the success, which means
  # the main "value" defined by actor.
  # In this main scenario we create a dataset of entity objects.
  # UseCase glues domain objects, events to pages. UseCase in a way is a model ? expand.... 
  class UseCase
    
    attr_accessor :scenario, :dataset
    
    class << self #eigenclass
      
      # from http://dictionary.reference.com/search?q=scenario
      # <tt>sce.nar.i.o</tt>
      # <td>an imagined or projected sequence of events, esp. any of several detailed plans or possibilities</td>
      # scenario is a list of scenes in sequence. each scene is a task UseCase is to perform to realize the UseCase
      # in this particular case the scenario we want to define is the main scenario a.k.a success scenario or simpley 'ha
      # usecase scenario. This scenario can build other scenarios of this usecase
      # There should be only one main scenario for this class.
      # if you want to run other scenarios you can instantiate this class and assign a different scenario. 
      # or subclass of this class to make a specialize scenario. Possibilities are endless.
      # we concentrate here on building a usecase from ground up. We concentrate in capturing in code a model
      # of successful UseCase. All other variations are going to be either in scenario of a usecase or in the same
      # scenario but slightly different dataset. Variations in datasets to the extent that the scenario remains the same
      # will give you a set of context tests for that particular scenario.
      # if you change scenario you can then alter datasets to provide test condtions for the scenario. and so on.
      def scenario(list_of_steps)
        class_eval "def set_default_scenario
                      @scenario = #{list_of_steps.inspect}
                    end
                    def scenario
                      @scenario ||= set_default_scenario
                    end
        "
      end
    end
    
    # usecase scenario runner. takes each task in scenario and runs it.
    # you can implement pre and post hooks here
    def run
      #log.info "UseCase:#{self.class.name} has #{scenario.size} tasks to run: #{scenario.inspect}"
      scenario.each do |task|
        #log.info "UseCase:#{self.class.name} task: #{task.inspect}"
        method, *args = task #if array pull first element as method and pass the rest
        self.send method, *args
      end
    end
  end
end
  
