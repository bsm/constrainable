require "spec_helper"

describe Bsm::Constrainable::Util do

  describe "hash normalization" do

    def norm(input)
      described_class.normalized_hash(input)
    end

    it { norm({}).should == {} }
    it { norm(nil).should == {} }
    it { norm({ 1 => 2, 3 => 4 }).should == { "1" => 2, "3" => 4 } }
    it { norm("A").should == {} }

  end

  describe "array normalization" do

    def norm(input)
      described_class.normalized_array(input)
    end

    it { norm([]).should == [] }
    it { norm(nil).should == [] }
    it { norm({}).should == [] }
    it { norm("A").should == ["A"] }
    it { norm(:A).should == ["A"] }
    it { norm([1,2,3]).should == ["1","2","3"] }
    it { norm([1,"2|3|4|5|6|  ||",3,4,5]).should == ["1","2","3","4","5","6"] }
    it { norm({ 1 => 2 }).should == ["1"] }

  end

end

