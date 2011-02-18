require "spec_helper"

describe Bsm::Constrainable::Relation do

  let(:relation) do
    Post.scoped
  end

  it 'should be includable' do
    relation.should respond_to(:constrain)
  end

  it 'should allow to apply constraints' do
    sql = relation.constrain(:author_id => {:in => [1, 2, 3]}, :created => { :gt => '2010-10-10' }).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1, 2, 3) AND (posts.created_at > '2010-10-10 00:00:00')"
  end

end

