require 'rails_helper'

RSpec.describe Choice, type: :model do
  include FactoryBot::Syntax::Methods
  let(:choice) { FactoryBot.create(:choice) }
  describe 'Checks the valid Choice' do
   it 'Presence of valid name' do
    choice = build(:choice)
     expect(choice).to be_valid
   end
  end
end
