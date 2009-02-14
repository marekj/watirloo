require File.dirname(__FILE__) + '/test_helper'

describe 'usecase' do
  
  class UC < Watirloo::UseCase
    scenario [:this, :that]
    def this
      $bla << 'this'
    end
    def that
      $bla << 'that'
    end
  end

  it 'has no scenarios' do
    Watirloo::UseCase.scenario []
  end

end





#class UC2 < UC
#  scenario %w|donotdothis donotdothat|
#end

