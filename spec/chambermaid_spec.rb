RSpec.describe Chambermaid do
  it "has a version number" do
    expect(Chambermaid::VERSION).not_to be nil
  end

  it "extends Chambermaid::Base" do
    expect(Chambermaid).to be_kind_of(Chambermaid::Base)
  end

  context ".configure" do
    it "accepts a block for configuration" do
      allow_any_instance_of(Chambermaid::Base).to receive(:load!)
      expect { |b| Chambermaid.configure(&b) }.to yield_control
    end
  end

  context ".add_namespace" do
    it "responds to add_namespace" do
      expect(Chambermaid).to respond_to(:add_namespace)
    end
  end

  context ".add_service" do
    it "responds to add_namespace" do
      expect(Chambermaid).to respond_to(:add_namespace)
    end
  end
end
