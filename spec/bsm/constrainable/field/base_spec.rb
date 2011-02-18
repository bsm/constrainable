require "spec_helper"

describe Bsm::Constrainable::Field::Base do

  let(:subject) do
    described_class.new("any")
  end

  def integer(opts = {})
    Bsm::Constrainable::Field::Integer.new("some", opts)
  end

  it { described_class.should have(7).operators }

  it 'should have a kind' do
    described_class.kind.should == :base
    integer.class.kind.should == :integer
  end

  it 'should allow setting operators' do
    integer.operators.should == Set.new([:eq])
    integer(:with => [:eq, :in, :gt]).operators.should == Set.new([:eq, :in, :gt])
  end

  it 'should allow using special attributes & clauses' do
    integer(:using => :other).attribute.should == :other
    integer(:using => lambda { }).attribute.should be_a(Proc)
  end

  it 'should convert inputs' do
    integer.convert(1).should == 1
    integer.convert([1, 2]).should == [1, 2]
    integer.convert([1, 'a', 2]).should == [1, nil, 2]
  end

end

