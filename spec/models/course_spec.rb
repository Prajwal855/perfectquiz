require 'rails_helper'

RSpec.describe Course, type: :model do
  include FactoryBot::Syntax::Methods
  let(:course) { FactoryBot.create(:course) }
  describe 'Checks the valid Course' do
   it 'Presence of valid name' do
    course = build(:course)
     expect(course).to be_valid
   end
  end
end
