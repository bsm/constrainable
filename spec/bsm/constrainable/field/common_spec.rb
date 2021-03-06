require "spec_helper"

describe "Common Fields" do

  let(:subject) { described_class.new('') }

  describe Bsm::Constrainable::Field::Number do
    it { subject.class.should have(9).operators }
    it { subject.convert("1").should == 1 }
    it { subject.convert("1a").should == nil }
    it { subject.convert([1, "2", 3]).should == [1, 2, 3] }
    it { subject.convert("1.5").should == 1.5 }
    it { subject.convert("a").should be_nil }
    it { subject.convert("").should be_nil }
    it { subject.convert(" ").should be_nil }
  end

  describe Bsm::Constrainable::Field::Integer do
    it { subject.class.should have(9).operators }
    it { should be_a(Bsm::Constrainable::Field::Number) }
    it { subject.convert("1.5").should == 1 }
  end

  describe Bsm::Constrainable::Field::Decimal do
    it { subject.class.should have(9).operators }
    it { should be_a(Bsm::Constrainable::Field::Number) }
  end

  describe Bsm::Constrainable::Field::String do
    it { subject.class.should have(2).operators }
    it { subject.convert(1).should == "1" }
    it { subject.convert(["a", 1]).should == ["a", "1"] }
    it { subject.convert("").should be_nil }
    it {
      subject.options[:allow_blank] = true
      subject.convert("").should == ""
    }
  end

  describe Bsm::Constrainable::Field::Timestamp do
    it { subject.class.should have(7).operators }
    it { subject.convert("a").should == nil }
    it { subject.convert("2010-01-01").should == Time.utc(2010) }
    it { subject.convert("2011-11-11 11:11").should == Time.utc(2011, 11, 11, 11, 11) }
  end

  describe Bsm::Constrainable::Field::Datetime do
    it { subject.class.should have(7).operators }
  end

  describe Bsm::Constrainable::Field::Date do
    it { subject.class.should have(7).operators }
    it { subject.convert("a").should == nil }
    it { subject.convert("2010-01-01").should == Date.civil(2010) }
    it { subject.convert("2011-11-11 11:11").should == Date.civil(2011, 11, 11) }
  end

  describe Bsm::Constrainable::Field::Boolean do
    it { subject.class.should have(2).operators }
    it { subject.convert("true").should == true }
    it { subject.convert("t").should == true }
    it { subject.convert("1").should == true }
    it { subject.convert(1).should == true }
    it { subject.convert("false").should == false }
    it { subject.convert("0").should == false }
    it { subject.convert("").should == nil }
    it { subject.convert("invalid").should == nil }
  end

end

