require 'rails_helper'

RSpec.describe Academic, type: :model do
    include FactoryBot::Syntax::Methods
    let(:user) {FactoryBot.create(:user)} 
    let(:intrest) {FactoryBot.create(:intrest)}
    let(:qualification) {FactoryBot.create(:qualification)}
    let(:academic) {FactoryBot.create(:academic)}
  
    describe 'Validation' do
      it 'valid Academic Record' do 
        academic = build(:academic, user_id: user.id, intrest_id: intrest.id, qualification_id: qualification.id)
           expect(academic).to be_valid
        end
      it 'validates presence of College Name' do
            academic = build(:academic, college_name: nil)
             expect(academic).not_to be_valid
             expect(academic.errors[:college_name]).to include("can't be blank")
        end
      it 'validates presence of Interest Id' do
         academic = build(:academic, intrest_id: nil)
         expect(academic).not_to be_valid
         expect(academic.errors[:intrest_id]).to include("can't be blank")
        end
 
      it 'validates presence of Qualification Id' do
        academic = build(:academic, qualification_id: nil)
        expect(academic).not_to be_valid
        expect(academic.errors[:qualification_id]).to include("can't be blank")
        end
  
      it 'validates presence of Career Goals' do
        academic = build(:academic, career_goals: nil)
        expect(academic).not_to be_valid
        expect(academic.errors[:career_goals]).to include("can't be blank")
      end

      it 'validates presence of Language' do
         academic = build(:academic, language: nil)
         expect(academic).not_to be_valid
         expect(academic.errors[:language]).to include("can't be blank")
      end
  
      it 'validates presence of Other Language' do
        academic = build(:academic, other_language: nil)
        expect(academic).not_to be_valid
        expect(academic.errors[:other_language]).to include("can't be blank")
      end

      it 'validates presence of Specialization' do
        academic = build(:academic, specialization: nil)
        expect(academic).not_to be_valid
        expect(academic.errors[:specialization]).to include("can't be blank")
      end

      it 'validates presence of Experiance' do
        academic = build(:academic, experiance: nil)
        expect(academic).not_to be_valid
        expect(academic.errors[:experiance]).to include("can't be blank")
      end

      it 'validates presence of User Id' do
         academic = build(:academic, user_id: nil)
         expect(academic).not_to be_valid
         expect(academic.errors[:user_id]).to include("can't be blank")
      end
    end
  
    describe 'associations' do
     it 'belongs to interest' do
         expect(Academic.reflect_on_association(:intrest).macro).to eq(:belongs_to)
      end

      it 'belongs to qualification' do
         expect(Academic.reflect_on_association(:qualification).macro).to eq(:belongs_to)
       end

       it 'belongs to user' do
         expect(Academic.reflect_on_association(:user).macro).to eq(:belongs_to)
      end
    end
end

