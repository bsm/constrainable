require "spec_helper"

describe Bsm::Constrainable::FilterSet do

  let :schema do
    Post._constrainable[:default].clone
  end

  let :relation do
    Post.send(:relation)
  end

  subject do
    filter_set 'author_id' => { 'in' => ['1', '2', '3'], 'lt' => '4' }, 'created' => { 'gt' => '2010-10-10' }, 'invalid' => "TRUE", 'empty' => {}
  end

  def filter_set(params = nil)
    described_class.new schema, params
  end

  it { should be_a(Hash) }

  it 'should store schema' do
    subject.schema.should == schema
  end

  it 'should normalize params' do
    subject.should == {"author_id"=>{:in=>["1", "2", "3"], :lt=>"4"}, "created"=>{:gt=>"2010-10-10"}}
  end

  it 'should merge params into relations' do
    sql = subject.merge(relation).to_sql
    sql.clean_sql.should == "SELECT posts.* FROM posts WHERE posts.author_id IN (1, 2, 3) AND (posts.created_at > '2010-10-10 00:00:00')"
  end

  it 'should have accessors to schema keys' do
    subject.should respond_to(:author_id)
    subject.author_id.should == { :in=>["1", "2", "3"], :lt=>"4" }
  end

  it 'should have form-processable accessors' do
    subject.should respond_to(:"author_id[in]")
    subject.send(:"author_id[in]").should == ["1", "2", "3"]

    subject.should respond_to("created[between]")
    subject.send("created[between]").should be_nil

    subject.should_not respond_to("author[gt]")
  end

  describe "in forms" do

    let :template do
      ActionView::Base.new
    end

    let :filters do
      filter_set 'author_id' => { 'in' => ['1', '2'] }, 'created' => { 'between' => ['2010-10-10', '2011-11-11'] }
    end

    def form(&block)
      builder = ::ActionView::Helpers::FormBuilder.new(:where, filters, template, {}, block)
      HTML::Document.new(block.call(builder))
    end

    it 'should be usable' do
      doc = form do |f|
        f.select :"author_id[in]", [1,2,3,4,5]
      end
      input = doc.find(:tag => "select")
      input['name'].should == "where[author_id[in]]"
      choices = input.find_all(:tag => 'option')
      choices.map {|n| n['value'] }.should =~ ['1', '2', '3', '4', '5']
      choices.select {|n| n['selected'] }.map {|n| n['value'] }.should =~ ['1', '2']
    end

  end
end

