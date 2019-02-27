# SPMS - secondary project management system

[![Build Status](https://gitlab.com/shaiju.edakulangara/spms/badges/staging/pipeline.svg)](https://gitlab.com/shaiju.edakulangara/spms/badges/staging/pipeline.svg)

SPMS is a tool for track timesheets of secondary projects with an organization. 

## Developer Setup

1. Install Ruby 2.5. (It is suggested to use a Ruby version manager such as [rbenv](https://github.com/rbenv/rbenv#installation) and then to [install Ruby 2.5](https://github.com/rbenv/rbenv#installing-ruby-versions)).
1. Install Bundler to manager dependencies: `gem install bundler`
1. Setup the database: `bundle exec rake db:migrate`

5. Start the application: `bundle exec rails s`

## Commands
- `bundle exec rubocop` - Run the full suite of linters on the codebase.
- `bundle exec rspec` - Run the full rspec tests.
- `bundle exec cucumber` - Run the full feature specs.

## Deployment Instructions

## TODO

## Documentation