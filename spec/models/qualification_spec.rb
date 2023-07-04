require 'rails_helper'

RSpec.describe Qualification, type: :model do
   include FactoryBot::Syntax::Methods
    let(:qualification) { FactoryBot.create(:qualification) }
    describe 'Checks the valid Qualification' do
     it 'Presence of valid name' do
       qualification = build(:qualification)
       expect(qualification).to be_valid
     end
    end
  end
