require 'rails_helper'

RSpec.describe Question, type: :model do
  include FactoryBot::Syntax::Methods
  let(:question) { FactoryBot.create(:question) }
  describe 'Checks the valid Question' do
   it 'Presence of valid name' do
    question = build(:question)
     expect(question).to be_valid
   end
  end
end
