# spec/models/subcategory_spec.rb
require 'rails_helper'

RSpec.describe Subcategory, type: :model do
  include FactoryBot::Syntax::Methods
  let(:category) {FactoryBot.create(:category)} 
  let(:subcategory) {FactoryBot.create(:subcategory)} 

  describe 'Validation' do
    it 'valid subcategory Record' do 
      subcategory = build(:subcategory, category_id: category.id)
         expect(subcategory).to be_valid
      end
    it 'validates presence of Name' do
      subcategory = build(:subcategory, name: nil)
           expect(subcategory).not_to be_valid
           expect(subcategory.errors[:name]).to include("can't be blank")
      end
    end
end
