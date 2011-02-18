require "spec_helper"

describe Bsm::Constrainable::Operation::Between do

  def subject(value = [1, 100])
    described_class.new(value, Post.scoped, Post._constrainable[:default]["id"].first)
  end

  it { should be_a(Bsm::Constrainable::Operation::Base) }

  it 'should parse' do
    subject.parsed.should == ['1', '100']
    subject("2...5").parsed.should == ['2', '5']
    subject("3..7").parsed.should == ['3', '7']
    subject("  2  ......  8   ").parsed.should == ['2', '8']
    subject("2010-01-01..2011-01-01").parsed.should == ['2010-01-01', '2011-01-01']
    subject(" ").parsed.should be_nil
    subject([1,2,3]).parsed.should be_nil
  end

  it "should build correct clauses" do
    subject("3..7").clause.to_sql.clean_sql.should == "posts.id >= 3 AND posts.id <= 7"
  end

end

