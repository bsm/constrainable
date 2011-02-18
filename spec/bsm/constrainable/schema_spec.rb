require "spec_helper"

describe Bsm::Constrainable::Schema do

  let(:subject) do
    Post._constrainable[:default].clone
  end

  it { should be_a(Hash) }

  it 'should store scopes by names' do
    subject.keys.should =~ ["author_id", "author_name", "category", "created", "id"]
  end

  it 'should have quick constraints' do
    subject.fields :id, :updated_at, :with => [:gt]
    subject.should have(6).items
    lambda { subject.fields(:cat) }.should raise_error(ArgumentError)
  end

  it 'should allow to append constraints' do
    subject.should have(5).items
    subject.integer :other, :using => :id
    subject.should have(6).items
  end

  it 'should allow to use definition short-cuts' do
    subject.integer :other, :using => :id
    subject.string  :name, :using => :category
    subject.should have(7).items
  end

  it 'should allow to use definition aliases' do
    subject.date :created_at
    subject.should have(6).items
  end

end

