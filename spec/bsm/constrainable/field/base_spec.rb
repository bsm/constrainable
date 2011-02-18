require "spec_helper"

describe Bsm::Constrainable::Field::Base do
  fixtures :all

  let(:subject) do
    described_class.new("any")
  end

  def integer(opts = {})
    Bsm::Constrainable::Field::Integer.new("some", opts)
  end

  def field(name)
    Post._constrainable[:default][name].first
  end

  def merge(name, params = {})
    field(name).merge(Post.scoped, params)
  end

  it { described_class.should have(7).operators }

  it 'should have a kind' do
    described_class.kind.should == :base
    integer.class.kind.should == :integer
  end

  it 'should allow setting operators' do
    integer.operators.should == Set.new([:eq, :not_eq])
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

  it 'should parse params and merge valid scopes' do
    merge("id", :in => [1, 2, 3]).where_sql.clean_sql.should == "WHERE posts.id IN (1, 2, 3)"
    merge("author_id", :in => [1, 3]).where_sql.clean_sql.should == "WHERE posts.author_id IN (1, 3)"
    merge("created", :between => "2010-01-01..2010-02-01", :gt => "2010-01-01").where_values.map(&:to_sql).map(&:clean_sql).
      should =~ ["posts.created_at >= '2010-01-01 00:00:00' AND posts.created_at <= '2010-02-01 00:00:00'", "posts.created_at > '2010-01-01 00:00:00'"]
  end

  it 'should include custom scopes' do
    rel = merge("author_name", :eq => "Alice")
    rel.includes_values.should == [:author]
    rel.where_sql.clean_sql.should == "WHERE authors.name = 'Alice'"
    rel.first.should == posts(:article)
  end

end

