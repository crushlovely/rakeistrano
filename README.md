# Rakeistrano

A Capistrano 3.x plugin for defining cap tasks that map to your application's Rake tasks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano', '~> 3.0.0'
gem 'rakeistrano'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rakeistrano

## Setup

``` ruby
require 'rakeistrano'
```

Then add a file named `config/rakeistrano.yml` in your project using the following format:

``` yaml
rake_tasks:
  - task: db:seed
    role: :worker # Role to run the task on (optional, defaults to :all)
    primary: true # Whether the task should only be run on the primary of the role specified. (optional, defaults to false)
```

Only `task` is required.  For example, if your YAML configuration looked like this:

``` yaml
rake_tasks:
  - task: cache:sweep
  - task: refresh:sitemap
    role: :app
  - task: db:update
    role: :worker
    primary: true
```

The following tasks would be available to you in Capistrano:

``` bash
$ cap -T
cap cache:sweep                  # rake task: rake cache:sweep, role: all, primary: false
cap refresh:sitemap              # rake task: rake refresh:sitemap, role: app, primary: false
cap db:update                    # rake task: rake db:update, role: worker, primary: true
```

You can add as many tasks to this YAML file as you like.

## Usage

Once you've set everything up, simply call your tasks directly (`cap cache:sweep`), or add them to your deploy flow:

``` ruby
namespace :deploy do
  after :publishing, 'cache:sweep'
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
