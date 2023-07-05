require 'rails_helper'

RSpec.describe Studymaterial, type: :model do
  include FactoryBot::Syntax::Methods
  let(:studymaterial) {FactoryBot.create(:studymaterial)} 

  describe 'Validation' do
    it 'valid Studymaterial Record' do 
      studymaterial = build(:studymaterial)
         expect(studymaterial).to be_valid
      end
    end
end
