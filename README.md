Guard::BDD
==========

BDD guard is an opinionated RSpec and Cucumber runner.

I like to partition my test suite into 3 or 4 groups:
- fast unit tests
- slower integration tests for interfaces to external libraries or services
- slow RSpec acceptance tests and/or
  slow Cucumber features

Whenever the test suite goes from red to green, I like my tests to be run in
the order given above. As soon as one group of tests fails to run successfully,
test execution stops.

Install
-------

Install the gem:

    $ gem install guard-bdd

or add it to your Gemfile:

``` ruby
gem 'guard-bdd'
```

Add guard definition to your Guardfile by running this command:

    $ guard init bdd

Guardfile
---------

``` ruby
guard 'bdd' do
  watch(%r{lib/(.*)\.rb$}) { |m| "spec/unit/#{File.basename(m[1])}_spec.rb"}
  watch(%r{spec/.*_spec\.rb})
end
```

Options
-------

You can configure the paths to the different test groups:

- `:unit_paths` defaults to `['spec/unit']`
- `:integration_paths` defaults to `['spec/integration']`
- `:acceptance_paths` defaults to `['spec/acceptance']`
- `:feature_paths` defaults to `['features']`

Development
-----------

* Source hosted at [GitHub](https://github.com/nistude/guard-bdd)
* Report Issues/Questions/Feature requests on [GitHub Issues](https://github.com/nistude/guard-bdd/issues)

Pull requests are very welcome! Make sure your patches are well tested. Please
create a topic branch for every separate change you make.

Bugs
----

Cucumber support is still missing.

Author
------

[Nikolay Sturm](http://blog.nistu.de/)
