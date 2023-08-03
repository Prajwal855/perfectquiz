# spec/models/course_spec.rb
require 'rails_helper'

RSpec.describe Course, type: :model do
  include FactoryBot::Syntax::Methods
  let(:course) { FactoryBot.create(:course) }
  let(:category) {FactoryBot.create(:category)} 
  let(:subcategory) {FactoryBot.create(:subcategory)} 
  describe 'Checks the valid Course' do
   it 'Presence of valid name' do
    course = build(:course, category_id: category.id, subcategory_id: subcategory.id)
     expect(course).to be_valid
   end
  end
end
