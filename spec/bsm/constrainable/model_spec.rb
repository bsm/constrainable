require "spec_helper"

describe Bsm::Constrainable::Model do

  let(:model) do
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

end

