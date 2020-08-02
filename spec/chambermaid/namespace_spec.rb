RSpec.describe Chambermaid::Namespace do
  before :each do
    allow(Chambermaid::ParameterStore).to receive(:new)
    allow_any_instance_of(Chambermaid::ParameterStore).to receive(:fetch_ssm_params!)
  end

  context "#new" do
    context ":path" do
      it "should accept a path param" do
        namespace = Chambermaid::Namespace.new(path: "/some/path")
        expect(namespace.instance_variable_get(:@path)).to eq("/some/path")
      end
    end

    context ":overload" do
      it "should not require overload param" do
        expect { Chambermaid::Namespace.new(path: "/some/path") }.to_not raise_error
      end

      it "should accept overload param" do
        namespace = Chambermaid::Namespace.new(path: "/some/path", overload: true)
        expect(namespace.instance_variable_get(:@overload)).to eq(true)
      end

      it "should be false by default" do
        namespace = Chambermaid::Namespace.new(path: "/some/path")
        expect(namespace.instance_variable_get(:@overload)).to eq(false)
      end
    end

    it "should create a new parameter store" do
      expect(Chambermaid::ParameterStore).to receive(:new)
      Chambermaid::Namespace.new(path: "/some/path")
    end

    it "should create a new environment" do
      expect(Chambermaid::Environment).to receive(:new)
      Chambermaid::Namespace.new(path: "/some/path")
    end
  end

  context "#load!" do
    before :each do
      allow(Chambermaid::ParameterStore).to receive(:new).and_call_original
      allow_any_instance_of(Chambermaid::ParameterStore).to receive(:params).and_return({ "A" => "b" })
      @namespace = Chambermaid::Namespace.new(path: "/some/path")
    end

    it "should load the parameter store" do
      expect(@namespace.instance_variable_get(:@store)).to receive(:load!)
      @namespace.load!
    end

    it "should load env" do
      allow(@namespace.instance_variable_get(:@store)).to receive(:params).and_return({})
      expect(@namespace).to receive(:load_env!)
      @namespace.load!
    end
  end

  context "#reload!" do
    before :each do
      allow(Chambermaid::ParameterStore).to receive(:new).and_call_original
      allow_any_instance_of(Chambermaid::ParameterStore).to receive(:params).and_return({ "A" => "b" })
      @namespace = Chambermaid::Namespace.new(path: "/some/path")
    end

    it "should reload parameter store" do
      expect(@namespace.instance_variable_get(:@env)).to receive(:unload!)
      expect(@namespace.instance_variable_get(:@store)).to receive(:reload!)
      expect(@namespace).to receive(:load_env!)
      @namespace.reload!
    end
  end

  context "#unload!" do
    before :each do
      allow(Chambermaid::ParameterStore).to receive(:new).and_call_original
      allow_any_instance_of(Chambermaid::ParameterStore).to receive(:params).and_return({ "A" => "b" })
      @namespace = Chambermaid::Namespace.new(path: "/some/path")
    end

    it "should unload parameters from ENV" do
      expect(@namespace.instance_variable_get(:@env)).to receive(:unload!)
      @namespace.unload!
    end
  end
end
