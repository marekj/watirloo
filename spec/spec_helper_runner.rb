# precondition for IE tests.
# configure the Spec::Runner
# to clear all browsers from desktop
# and clear locker then sleep to make sure all browser proceses finished.
# This file is used by rakefile global all test runner
require 'spec'
Spec::Runner.configure do |config|
  config.before(:all) do
    Watirloo::Desktop.clear
    Watirloo::Locker.clear
  end
end

