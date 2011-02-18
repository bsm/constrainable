require "spec_helper"

describe "Common Operations" do

  def new_op(sym)
    Bsm::Constrainable::Operation.new sym, "", Post.scoped, Post._constrainable[:default]["id"].first
  end

  [:eq, :not_eq, :gt, :lt, :gteq, :lteq].each do |sym|
    it { new_op(sym).should be_a(Bsm::Constrainable::Operation::Base) }
    it { new_op(sym).should_not be_instance_of(Bsm::Constrainable::Operation::Base) }
  end

end

