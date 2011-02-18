require "spec_helper"

describe Bsm::Constrainable::Operation::In do

  def subject
    Bsm::Constrainable::Operation.new :in, "1|2|3", Post.scoped, Post._constrainable[:default]["id"].first
  end

  it { should be_instance_of(described_class) }
  it { should be_a(Bsm::Constrainable::Operation::Collection) }

  it 'should generate correct clauses' do
    subject.clause.to_sql.clean_sql.should == "posts.id IN (1, 2, 3)"
  end

end

