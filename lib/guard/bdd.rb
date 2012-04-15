require 'guard'
require 'guard/guard'
require 'guard/bdd/state_machine'

module Guard
  class Bdd < Guard
    VERSION = '0.0.1'

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
      options = {
        :acceptance_paths  => ['spec/acceptance'],
        :feature_paths     => ['features'],
        :integration_paths => ['spec/integration'],
        :unit_paths        => ['spec/unit']
      }.merge(options)
      @state_machine = StateMachine.new(options)
    end

    # Call once when Guard starts. Please override initialize method to init
    # stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      @state_machine.startup
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all
    # specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      @state_machine.run_all
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_change(paths)
      @state_machine.changed_paths = paths
      @state_machine.run_on_change
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_deletion(paths)
      @state_machine.remove(paths)
    end
  end
end
