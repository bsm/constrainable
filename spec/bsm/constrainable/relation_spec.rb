require "spec_helper"

describe Bsm::Constrainable::Relation do

  let :relation do
    Post.send(:relation)
  end

  it 'should be includable' do
    relation.should respond_to(:constrain)
  end

  it 'should apply constraints as parameters' do
    sql = relation.constrain(:author_id => {:in => [1, 2, 3]}, :created => { :gt => '2010-10-10' }).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1, 2, 3) AND (posts.created_at > '2010-10-10 00:00:00')"
  end

  it 'should apply constraints as filter-sets' do
    filters = Post.constrainable.filter(:author_id => {:in => 1})
    sql = relation.constrain(filters).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1)"
  end

  it 'should respect constranable scopes' do
    sql = relation.constrain(:default, :author_id => {:in => 1}).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1)"

    sql = relation.constrain(:missing, :author_id => {:in => 1}).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts"
  end

end

