# spec/models/category_spec.rb
require 'rails_helper'

RSpec.describe Category, type: :model do
  include FactoryBot::Syntax::Methods
  let(:category) {FactoryBot.create(:category)} 

  describe 'Validation' do
    it 'valid Category Record' do 
      category = build(:category)
         expect(category).to be_valid
      end
    it 'validates presence of Name' do
      category = build(:category, name: nil)
           expect(category).not_to be_valid
           expect(category.errors[:name]).to include("can't be blank")
      end
    end
end
