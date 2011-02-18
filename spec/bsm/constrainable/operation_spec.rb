require "spec_helper"

describe Bsm::Constrainable::Operation do

  it { should be_a(Bsm::Constrainable::Registry) }

  it 'should have a registry' do
    described_class.registry.should have(9).items
  end

end

