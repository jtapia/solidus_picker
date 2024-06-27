require 'spec_helper'

RSpec.describe SolidusPicker do
  describe 'VERSION' do
    it 'is defined' do
      expect(SolidusPicker::VERSION).to be_present
    end
  end
end
