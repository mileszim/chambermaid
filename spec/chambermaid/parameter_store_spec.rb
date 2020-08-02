RSpec.describe Chambermaid::ParameterStore do
  before :each do
    allow_any_instance_of(Chambermaid::ParameterStore).to receive(:client).and_return(
      Aws::SSM::Client.new(stub_responses: {
        get_parameters_by_path: {
          parameters: [
            {
              name: "/some/path/var_a",
              value: "a"
            },{
              name: "/some/path/var_b",
              value: "b"
            }
          ]
        }
      })
    )

    @store = Chambermaid::ParameterStore.new(path: "/some/path")
  end

  context ".new" do
    it "accepts a path string arg" do
      expect(@store.instance_variable_get(:@path)).to eq("/some/path")
    end

    it "should have nil params" do
      expect(@store.instance_variable_get(:@params_list)).to eq(nil)
      expect(@store.instance_variable_get(:@params)).to eq(nil)
    end
  end

  context "#load!" do
    it "should fetch all params from ssm namespace" do
      expect(@store.instance_variable_get(:@params_list)).to eq(nil)
      expect(@store.instance_variable_get(:@params)).to eq(nil)
      @store.load!
      expect(@store.params).to include("VAR_A" => "a", "VAR_B" => "b")
    end
  end

  context "#reload!" do
    before :each do
      @store.load!
    end

    it "should reload ssm params from namespace" do
      expect(@store.params).to include("VAR_A" => "a", "VAR_B" => "b")
      expect(@store.params).to_not include("VAR_C" => "c", "VAR_D" => "d")

      allow_any_instance_of(Chambermaid::ParameterStore).to receive(:client).and_return(
        Aws::SSM::Client.new(stub_responses: {
          get_parameters_by_path: {
            parameters: [
              {
                name: "/some/path/var_c",
                value: "c"
              },{
                name: "/some/path/var_d",
                value: "d"
              }
            ]
          }
        })
      )

      @store.reload!

      expect(@store.params).to_not include("VAR_A" => "a", "VAR_B" => "b")
      expect(@store.params).to include("VAR_C" => "c", "VAR_D" => "d")
    end
  end
end
