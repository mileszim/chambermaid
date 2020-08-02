RSpec.describe Chambermaid::Base do
  before :each do
    stub_const('ENV', ENV)
  end

  context "extended" do
    before :each do
      allow(Chambermaid::Base).to receive(:load!)
      allow(Chambermaid::Base).to receive(:add_namespace)
      allow(Chambermaid::Namespace).to receive(:load!)
      allow(Chambermaid::ParameterStore).to receive(:new)
    end

    it "makes a copy of the ENV state on load" do
      original_env = Chambermaid::Base.class_variable_get(:@@_original_env).to_h.values
      expect(original_env).to eql(ENV.to_h.values)
      Chambermaid.add_namespace("sdf")
    end
  end

  context ".configure" do
    it "yields Chambermaid::Base" do
      allow(Chambermaid::Base).to receive(:load!)
      expect { |b| Chambermaid::Base.configure(&b) }.to yield_with_args(Chambermaid::Base)
    end

    it "allows adding namespaces" do
      allow(Chambermaid::Base).to receive(:load!)
      expect(Chambermaid::Base).to receive(:add_namespace)

      Chambermaid::Base.configure do |config|
        config.add_namespace("/some/namespace")
      end
    end

    it "allows adding services" do
      allow(Chambermaid::Base).to receive(:load!)
      expect(Chambermaid::Base).to receive(:add_service)

      Chambermaid::Base.configure do |config|
        config.add_service("some/namespace")
      end
    end

    it "allows calls load! after yield" do
      allow(Chambermaid::Base).to receive(:add_namespace)
      expect(Chambermaid::Base).to receive(:load!)

      Chambermaid::Base.configure do |config|
        config.add_service("some/namespace")
      end
    end
  end

  context ".add_namespace" do
    context "args" do
      context ":path" do
        before :each do
          allow(Chambermaid::Namespace).to receive(:load!)
        end

        it "raises when path parameter is not a string" do
          expect {
            Chambermaid::Base.add_namespace(1234)
          }.to raise_error(ArgumentError)

          expect {
            Chambermaid::Base.add_namespace
          }.to raise_error(ArgumentError)
        end
      end

      context ":overload" do
        before :each do
          allow(Chambermaid::Namespace).to receive(:load!)
        end

        it "is false by default" do
          expect(Chambermaid::Namespace).to receive(:load!).with(path: "/some/path", overload: false)
          Chambermaid::Base.add_namespace("/some/path")
        end

        it "is can be set true" do
          expect(Chambermaid::Namespace).to receive(:load!).with(path: "/some/path", overload: true)
          Chambermaid::Base.add_namespace("/some/path", overload: true)
        end

        it "raises when parameter is not a boolean" do
          expect {
            Chambermaid::Base.add_namespace("/some/namespace", overload: 1234)
          }.to raise_error(ArgumentError)

          expect {
            Chambermaid::Base.add_namespace("/some/namespace", overload: nil)
          }.to raise_error(ArgumentError)
        end
      end
    end
  end

  context ".logger" do
    it "should have a default Logger instance" do
      expect(Chambermaid::Base.logger).to be_kind_of(Logger)
    end

    it "can be set to a custom logger" do
      custom_logger = Logger.new(STDOUT)
      expect(Chambermaid::Base.logger).to_not be(custom_logger)
      Chambermaid::Base.logger = custom_logger
      expect(Chambermaid::Base.logger).to be(custom_logger)
    end
  end

  context ".log_level" do
    it "should have a default level" do
      expect(Chambermaid::Base.log_level).to_not be_nil
    end

    it "can be set to a custom level" do
      Chambermaid::Base.log_level = :info
      expect(Chambermaid::Base.log_level).to_not be(Logger::DEBUG)
      Chambermaid::Base.log_level = :debug
      expect(Chambermaid::Base.log_level).to be(Logger::DEBUG)
    end
  end

  # context ".load!" do
  #   it "should load each namespace" do
  #     expect(Chambermaid::Base.instance_variable_get(:@namespaces)).to receive(:each).with(&:load!)
  #     Chambermaid::Base.load!
  #   end
  # end
end
