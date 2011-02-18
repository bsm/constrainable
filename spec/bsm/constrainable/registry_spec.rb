require "spec_helper"

describe Bsm::Constrainable::Registry do

  let(:subject) do
    Bsm::Constrainable::Field
  end

  it 'should check registry' do
    subject.registered?(:string).should be(true)
    subject.registered?("string").should be(true)
    subject.registered?(:invalid).should be(false)
  end

  it 'should instantiate new constraints' do
    subject.new(:string, "some").should be_a(Bsm::Constrainable::Field::String)
    subject.new(:date, "other").should be_a(Bsm::Constrainable::Field::Date)
    lambda { subject.new(:invalid, "wrong") }.should raise_error(ArgumentError)
  end

end

