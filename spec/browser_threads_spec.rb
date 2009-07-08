require File.dirname(__FILE__) + '/spec_helper'
require 'thread'

# This is more of an example of using Watirloo::browser() and Watirloo::Locker with threads
# for multibrowser testing possiblilities
describe "concurrent threaded usage of locker for multibrowser tests" do

  context "when I work with 5 browsers at once" do

    it "Watirloo.browser opens new browsers and adds them to locker"  do
      threads = []
      1.upto(5) do |i|
        threads << Thread.new { Watirloo.browser(i) }
      end
      threads.each {|x| x.join}
    end

    it 'Watirloo.browser uses locker to reattach to 5 browsers and load 5 diff pages at once' do
      threads = []
      files = ['census.html', 'labels.html', 'person.html', 'select_lists.html', 'radio_group.html']
      titles = ['Census', 'Labels', 'Person', 'select lists', "radio_groups"]
      1.upto(5) do |i|
        threads << Thread.new do
          Watirloo.browser(i).goto testfile(files[i-1])
          Watirloo.browser(i).title.should == titles[i-1]
        end
      end
      threads.each {|x| x.join}
    end

    it "reattaches and closes all 5 browsers" do
      hwnds = Watirloo::Desktop.hwnds
      threads =[]
      1.upto(5) { |i| threads << Thread.new { Watirloo.browser(i).close } }
      threads.each {|x| x.join}
      sleep 5 #Ensure browsers close
      Watirloo::Desktop.deletions(hwnds).size.should == 5
    end
  end
end
