require 'rails_helper'

RSpec.describe Chapter, type: :model do
  include FactoryBot::Syntax::Methods
  let(:chapter) { FactoryBot.create(:chapter) }
  describe 'Checks the valid Chapter' do
   it 'Presence of valid name' do
    chapter = build(:chapter)
     expect(chapter).to be_valid
   end
  end
end
