require 'rails_helper'

RSpec.describe Chapter, type: :model do
  include FactoryBot::Syntax::Methods
  let(:course) { FactoryBot.create(:course) }
  let(:chapter) { FactoryBot.create(:chapter) }
  describe 'Checks the valid Chapter' do
   it 'Presence of valid name' do
    chapter = build(:chapter, course_id: course.id)
     expect(chapter).to be_valid
   end
  end
end
