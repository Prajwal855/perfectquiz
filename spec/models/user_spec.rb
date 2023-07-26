require 'rails_helper'

RSpec.describe User, type: :model do
  include FactoryBot::Syntax::Methods
  let(:user) {FactoryBot.create(:user)} 

  describe 'Validation' do
    it 'valid User Record' do 
      user = build(:user, role: "teacher")
         expect(user).to be_valid
      end
    it 'validates presence of Email' do
      user = build(:user, email: nil)
           expect(user).not_to be_valid
           expect(user.errors[:email]).to include("can't be blank")
      end
    it 'validates presence of Password' do
      user = build(:user, password: nil)
       expect(user).not_to be_valid
       expect(user.errors[:password]).to include("can't be blank")
      end

    it 'validates presence of Role' do
      user = build(:user, role: "teacher")
      expect(user).to be_valid
      end
    end
end
