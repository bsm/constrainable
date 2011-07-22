require "spec_helper"

describe Bsm::Constrainable::Model do
  fixtures :posts

  let :model do
    Class.new(ActiveRecord::Base)
  end

  it 'should be includable' do
    model.send(:included_modules).should include(described_class)
  end

  it 'should allow to define a schema' do
    res = nil
    model._constrainable.should be_a(Hash)
    model.constrainable { res = self.class.name }
    model._constrainable.keys.should == [:default]
    res.should == "Bsm::Constrainable::Schema"
  end

  it 'should allow to define custom schemata' do
    model.constrainable("custom") { }
    model._constrainable.keys.should == [:custom]
  end

  it 'should allow to retrieve the schema without definition' do
    model.constrainable.should be_a(Bsm::Constrainable::Schema)
  end

  it 'should delegate constrain to relation' do
    sql = Post.constrain(:author_id => {:in => 1}).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1)"
  end

  it 'should retain relation scopes' do
    Post.articles.should have(1).record
    Post.articles.constrain(:author_id => {:in => 1}).should have(1).record
    Post.articles.constrain(:author_id => {:in => 2}).should have(:no).records
    Post.constrain(:author_id => {:in => 2}).should have(1).record
  end

end

