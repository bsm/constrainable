require "spec_helper"

describe Bsm::Constrainable::Operation::Collection do

  def subject(value = "1|2|3")
    described_class.new value, Post.scoped, Post._constrainable[:default]["id"].first
  end

  it { should be_a(Bsm::Constrainable::Operation::Base) }

  it 'should parse' do
    subject.parsed.should == ['1', '2', '3']
    subject("1|a|b|2|3||  ").parsed.should == ['1', 'a', 'b', '2', '3']
  end

end

