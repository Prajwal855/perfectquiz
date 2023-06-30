require 'rails_helper'

RSpec.describe Intrest, type: :model do
  let(:intrest) { FactoryBot.create(:intrest)}
  describe 'validate the name' do
    it 'Name is nil' do
     interest = build(:intrest, name: '')
      expect(intrest).not_to be_valid
      expect(intrest.errors[:name]).to include("can't be blank")
  end

   it 'Name is Present' do 
    intrest = build(:intrest)

    expect(intrest).to be_valid
    end
  end
end
