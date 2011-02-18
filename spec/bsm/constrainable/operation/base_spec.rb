require "spec_helper"

describe Bsm::Constrainable::Operation::Base do

  def field
    Post._constrainable[:default]["id"].first
  end

  def subject
    described_class.new(123, Post.scoped, field)
  end

  def new_op(kind, value)
    Bsm::Constrainable::Operation.new(kind, value, Post.scoped, field)
  end

  it 'should have a value' do
    subject.value.should == 123
  end

  it 'should parse' do
    subject.parsed.should == '123'
  end

  it 'should generate comparison clauses' do
    new_op(:eq, 1).clause.to_sql.clean_sql.should == "posts.id = 1"
    new_op(:not_eq, 1).clause.to_sql.clean_sql.should == "posts.id != 1"
    new_op(:in, "1|2|3").clause.to_sql.clean_sql.should.should == "posts.id IN (1, 2, 3)"
    new_op(:gteq, 1).clause.to_sql.clean_sql.should == "posts.id >= 1"
    new_op(:between, "4..8").clause.to_sql.clean_sql.should == "posts.id >= 4 AND posts.id <= 8"
  end

  it 'should ignore invalid combinations' do
    new_op(:eq, "a").clause.should be_nil
    new_op(:in, "1|a|2").clause.should be_nil
    new_op(:between, "2..a").clause.should be_nil
  end

end

