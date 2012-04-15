require 'state_machine'
require 'guard/rspec/runner'
require 'guard/rspec/inspector'

module Guard
  class Bdd < Guard
    class StateMachine
      attr_writer :changed_paths

      state_machine :bdd, :initial => :cold do
        # startup
        state :cold

        event :startup do
          transition :from => :cold, :to => :run_all
        end

        # generic states
        state :run_all
        after_transition :to => :run_all, :do => :run_all_unit_specs

        state :test_failure
        after_transition :to => :test_failure, :do => :throw_up

        state :test_success

        # generic events
        event :run_all do
          transition :to => :run_all
        end

        state :run_on_change_green
        after_transition :to => :run_on_change_green, :do => :run_changed

        state :run_on_change_red
        after_transition :to => :run_on_change_red, :do => :run_changed

        event :run_on_change do
          transition :from => :test_success, :to => :run_on_change_green
          transition :from => :test_failure, :to => :run_on_change_red
        end

        event :run_changed_success do
          transition :from => :run_on_change_green, :to => :test_success
          transition :from => :run_on_change_red, :to => :run_all
        end

        event :run_changed_failure do
          transition :to => :test_failure
        end

        # unit specs
        event :unit_specs_success do
          transition :to => :unit_specs_green
        end
        event :unit_specs_failure do
          transition :to => :test_failure
        end

        state :unit_specs_green
        after_transition :to => :unit_specs_green, :do => :run_all_integration_specs

        # integration specs
        event :integration_specs_success do
          transition :to => :integration_specs_green
        end
        event :integration_specs_failure do
          transition :to => :test_failure
        end

        state :integration_specs_green
        after_transition :to => :integration_specs_green, :do => :run_all_acceptance_specs

        # acceptance specs
        event :acceptance_specs_success do
          transition :to => :acceptance_specs_green
        end
        event :acceptance_specs_failure do
          transition :to => :test_failure
        end

        state :acceptance_specs_green
        after_transition :to => :acceptance_specs_green, :do => :run_all_cucumber_features

        # cucumber features
        event :cucumber_features_success do
          transition :to => :test_success
        end
        event :cucumber_features_failure do
          transition :to => :test_failure
        end
      end

      def initialize(options)
        @options = options
        @changed_paths = []
        @failed_paths = []

        @rspec_runner = RSpec::Runner.new(@options)

        super()
      end

      def remove(paths)
        @failed_paths -= paths
      end

      private
      def run_all_acceptance_specs
        paths = @options[:acceptance_paths].select { |path| File.exist?(path) }
        if paths.empty?
          acceptance_specs_success
        else
          passed = @rspec_runner.run(paths)
          passed ? acceptance_specs_success : acceptance_specs_failure
        end
      end

      def run_all_cucumber_features
        # passed = @cucumber_runner.run(@options[:feature_paths])
        # if passed
        #   @failed_paths = []
            cucumber_features_success
        # else
        #   cucumber_features_failure
        # end
      end

      def run_all_integration_specs
        paths = @options[:integration_paths].select { |path| File.exist?(path) }
        if paths.empty?
          integration_specs_success
        else
          passed = @rspec_runner.run(paths)
          passed ? integration_specs_success : integration_specs_failure
        end
      end

      def run_all_unit_specs
        paths = @options[:unit_paths].select { |path| File.exist?(path) }
        if paths.empty?
          unit_specs_success
        else
          passed = @rspec_runner.run(paths)
          passed ? unit_specs_success : unit_specs_failure
        end
      end

      def run_changed
        paths = @changed_paths
        paths += @failed_paths

        spec_paths = []
        [:acceptance_paths, :integration_paths, :unit_paths].each do |path|
          spec_paths += @options[path]
        end
        paths = RSpec::Inspector.new(:spec_paths => spec_paths).clean(paths)

        if paths.empty?
          @changed_paths = []
          run_changed_success
        else
          passed = @rspec_runner.run(paths)
          @changed_paths = []
          if passed
            @failed_paths -= paths
            run_changed_success
          else
            @failed_paths = (@failed_paths + paths).uniq
            run_changed_failure
          end
        end
      end

      def throw_up
        throw :task_has_failed
      end
    end
  end
end
