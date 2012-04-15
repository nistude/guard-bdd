require 'guard/bdd'

describe Guard::Bdd::StateMachine do
  let(:runner) { double(Guard::RSpec::Runner) }
  let(:state_machine) {
    state_machine = Guard::Bdd::StateMachine.new(
      :acceptance_paths  => ['acceptance'],
      :features_path     => ['feature'],
      :integration_paths => ['integration'],
      :unit_paths        => ['unit']
    )
  }

  before(:each) do
    runner.stub(:run).and_return(true)
    Guard::RSpec::Runner.stub(:new).and_return(runner)

    File.stub(:exist?).and_return(true)
  end

  context 'on startup' do
    it 'runs all test groups' do
      state_machine.startup

      state_machine.bdd.should == 'test_success'
    end
  end

  context 'when a test directory does not exist' do
    %w{unit integration acceptance feature}.each do |kind|
      it "skips missing #{kind} tests" do
        File.stub(:exist?).with(kind).and_return(false)

        runner.should_not_receive(:run).with([kind])

        state_machine.startup
      end
    end
  end

  context 'when a single test fails' do
    it 'keeps that test on the run list until all tests succeed' do
      state_machine.bdd = 'test_success'

      inspector = double(Guard::RSpec::Inspector)
      inspector.stub(:clean).and_return(['foo'], ['bar', 'foo'])
      Guard::RSpec::Inspector.stub(:new).and_return(inspector)

      runner.stub(:run).with(['foo']).and_return(false)
      state_machine.changed_paths = ['foo']
      expect { state_machine.run_on_change }.to throw_symbol(:task_has_failed)
      state_machine.instance_variable_get(:@failed_paths).should == ['foo']
      state_machine.bdd.should == 'test_failure'

      state_machine.changed_paths = ['bar']
      state_machine.run_on_change
      state_machine.bdd.should == 'test_success'
      state_machine.instance_variable_get(:@failed_paths).should == []
    end
  end
end
