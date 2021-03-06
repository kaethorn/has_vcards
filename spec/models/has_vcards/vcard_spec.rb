require 'rails_helper'

describe HasVcards::Vcard do
  before { @vcard = FactoryGirl.create :vcard }

  it 'has a valid factory' do
    expect(@vcard).to be_valid
  end

  describe 'name validation' do

    it 'accepts vcards with a full name' do
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'accepts vcards with a given name' do
      @vcard.full_name = nil
      @vcard.given_name = 'Ben'
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'accepts vcards with a family name' do
      @vcard.full_name = nil
      @vcard.family_name = 'Hur'
      @vcard.validate_name

      expect(@vcard.errors).to be_empty
    end

    it 'rejects vcards without a full name' do
      @vcard.full_name = nil
      @vcard.validate_name

      expect(@vcard.errors.size).to be 3
    end
  end

  describe 'full name generation' do

    describe 'with an existing full name' do

      it 'returns the same name' do
        expect(@vcard.full_name).to eq 'Ben Hur'
      end
    end

    describe 'without an existing full name' do
      before { @vcard.full_name = nil }

      it 'constructs a full name from family- and given name' do
        @vcard.family_name = 'Clark'
        @vcard.given_name  = 'Louis'

        expect(@vcard.full_name).to eq 'Clark Louis'
      end
    end
  end

  describe 'abbreviated name generation' do

    describe 'with an existing full name' do

      it 'returns the same name' do
        expect(@vcard.abbreviated_name).to eq 'Ben Hur'
      end
    end

    describe 'without an existing full name' do
      before { @vcard.full_name = nil }

      it 'constructs a full name from family- and given name' do
        @vcard.family_name = 'Clark'
        @vcard.given_name  = 'Louis Anderson'

        expect(@vcard.abbreviated_name).to eq 'L. Clark'
      end
    end
  end

  describe 'address lines helper' do

    it 'only returns non empty lines' do
      @vcard.street_address   = '1234 Foobar Street'
      @vcard.post_office_box  = '09823'

      expect(@vcard.address_lines.size).to be 2
    end
  end

  describe 'full address lines helper' do

    it 'only returns the full address and name' do
      @vcard.street_address   = '1234 Foobar Street'
      @vcard.post_office_box  = '09823'

      expect(@vcard.full_address_lines.size).to be 3
    end
  end

  describe 'contact lines helper' do
    before do
      3.times { FactoryGirl.create :phone_number, vcard: @vcard }
    end

    it 'only returns the full address and name' do
      expect(@vcard.contacts.size).to eq 3
      expect(@vcard.contact_lines.size).to eq 3
    end
  end
end
