require "spec_helper"

describe Bsm::Constrainable::Operation::NotIn do

  def subject
    Bsm::Constrainable::Operation.new :not_in, "1|2", Post.scoped, Post._constrainable[:default]["id"].first
  end

  it { should be_instance_of(described_class) }
  it { should be_a(Bsm::Constrainable::Operation::Collection) }

  it 'should generate correct clauses' do
    subject.clause.to_sql.clean_sql.should == "posts.id NOT IN (1, 2)"
  end

end

