require 'rails_helper'

RSpec.describe User, type: :model do
  let(:profile_attrs) { { street: '123 street', zip: '12345' } }

  it 'functions as normal without uniqueness issues' do
    user = User.new(email: 'some@email.com')
    user.build_profile(profile_attrs)
    user.save

    aggregate_failures do
      # these do not fail

      expect(user).to be_persisted
      expect(user.profile).to be_persisted

      expect { user.reload }.not_to raise_error
      expect { user.profile.reload }.not_to raise_error
    end
  end

  describe 'saving user with non-unique profile' do
    it 'should not raise ActiveRecord::StatementInvalid' do
      # with transactional fixtures enabled, the failure raises an
      # ActiveRecord::StatementInvalid exception
      expect {
        Profile.create(profile_attrs)
        user = User.new(email: 'some@email.com')
        user.build_profile(profile_attrs)
        user.save
      }.not_to raise(ActiveRecord::StatementInvalid)
    end

    context 'with transactional fixtures disabled', use_transactional_fixtures: false do
      after do
        Profile.destroy_all
        User.destroy_all
      end

      it 'should not return an id on user when it is not persisted' do
        Profile.create(profile_attrs)
        user = User.new(email: 'some@email.com')
        user.build_profile(profile_attrs)
        user.save

        aggregate_failures do
          # this is failing
          expect(user.id).not_to be_present

          # this is failing
          expect(user.errors).to be_present

          # this does not fail
          expect(user.profile.id).not_to be_present

          # this does not fail
          expect(user.profile.errors[:street]).to include 'has already been taken'

          # this is failing
          expect { user.reload }.not_to raise(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
