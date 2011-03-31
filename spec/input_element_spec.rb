require 'spec_helper'

module Watir
  module Container

    def input_label(label)
      what = self.label(:text, label).for
      raise "label for attribute is blank" if what == ""
      input_id(what)
    end

    # If user knowns the Label that has a for attribute pointing to an element we can access that element by
    # input_element(:lable, 'Text Of Label')
    def input_id(what)
      raise "provide a String for Id" unless what.kind_of?(String)
      # for input_element('bla') convention to (:id,'bla')
      mystery_element = self.document.getElementById(what)
      raise 'Element not found' unless mystery_element
      mystery_type = mystery_element.invoke('type')
      return text_field(:id, what) if TextField::INPUT_TYPES.include? mystery_type
      return select_list(:id, what) if SelectList::INPUT_TYPES.include? mystery_type
      # TODO working on this 
    end
  end

end

describe 'Mystery input element' do

  include Watirloo::Page
  
  before do
    browser.goto testfile('labels.html')
  end

  it 'the id is text_field' do
    browser.input_id('first_nm').should be_kind_of(Watir::TextField)
  end

  it 'the label points to text_field' do
    browser.input_label('FirstName For').should be_kind_of(Watir::TextField)
  end

  it "the id should return select_list" do
    browser.input_id('gender_code').should be_kind_of(Watir::SelectList)
  end
  
  
end


