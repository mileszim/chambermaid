RSpec.describe Chambermaid::Environment do
  before :each do
    stub_const("ENV", ENV)
  end

  context "#new" do
    it "accepts a hash" do
      expect(Chambermaid::Environment.new({})).to be_instance_of(Chambermaid::Environment)
    end

    it "raises if not hash-like param" do
      expect {
        Chambermaid::Environment.new
      }.to raise_error(ArgumentError)

      expect {
        Chambermaid::Environment.new("sdf")
      }.to raise_error(ArgumentError)
    end
  end

  context "#params" do
    it "has a params hash" do
      env = Chambermaid::Environment.new({ "a" => "b" })
      expect(env).to eq({ "A" => "b" })
    end
  end

  context "#to_dotenv" do
    it "generates a dotenv compatible string" do
      env = Chambermaid::Environment.new({ "a" => "b" })
      expect(env.to_dotenv).to eq("A=b\n")
    end
  end

  context "#to_h" do
    it "returns a hash" do
      env = Chambermaid::Environment.new({ "a" => "b" })
      expect(env.to_h).to eq({ "A" => "b" })
    end
  end

  context "#load!" do
    before :each do
      @env = Chambermaid::Environment.new({ "a" => "b" })
    end

    it "loads params into ENV" do
      expect(ENV["A"]).to be_nil
      @env.load!
      expect(ENV["A"]).to eq("b")
    end

    it "keeps current value of duplicate key" do
      ENV["A"] = "not b"
      @env.load!
      expect(ENV["A"]).to eq("not b")
    end
  end

  context "#overload!" do
    before :each do
      @env = Chambermaid::Environment.new({ "a" => "b" })
    end

    it "loads params into ENV" do
      expect(ENV["A"]).not_to eq("b")
      @env.overload!
      expect(ENV["A"]).to eq("b")
    end

    it "overwrites value of duplicate key" do
      ENV["A"] = "not b"
      @env.overload!
      expect(ENV["A"]).to eq("b")
    end
  end

  context "#unload!" do
    before :each do
      stub_const("ENV", { "ORIGINAL" => "ENV" })
      @env = Chambermaid::Environment.new({ "a" => "b" })
    end

    it "unloads injected params from ENV" do
      @env.load!
      expect(ENV["ORIGINAL"]).to eq("ENV")
      expect(ENV["A"]).to eq("b")
      @env.unload!
      expect(ENV["ORIGINAL"]).to eq("ENV")
      expect(ENV["A"]).to eq(nil)
    end
  end
end
