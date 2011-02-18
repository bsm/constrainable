require "spec_helper"

describe Bsm::Constrainable::Operation::Matches do

  def subject
    Bsm::Constrainable::Operation.new :matches, "%bob%", Post.scoped, Post._constrainable[:default]["author_name"].first
  end

  it { should be_instance_of(described_class) }
  it { should be_a(Bsm::Constrainable::Operation::Base) }

  it 'should generate correct clauses' do
    subject.clause.to_sql.clean_sql.should == "authors.name LIKE '%bob%'"
  end

end

