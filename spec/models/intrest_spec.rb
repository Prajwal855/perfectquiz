require 'rails_helper'

RSpec.describe Intrest, type: :model do
  include FactoryBot::Syntax::Methods
  let(:intrest) { FactoryBot.create(:intrest)}
  describe 'validate the name' do
   it 'Name is Present' do 
    intrest = build(:intrest)
    expect(intrest).to be_valid
    end
  end
end
