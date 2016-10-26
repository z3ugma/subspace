# Subspace

Subspace is a rubygem meant to make provisioning as easy as Capistrano makes deploying.

http://tvtropes.org/pmwiki/pmwiki.php/Main/SubspaceAnsible

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'subspace'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install subspace

Then run

    subspace init

## Updating

After updating the subspace gem in your project, you will have to edit
`config/provision/ansible.cfg` to change the roles path to use the new
gem directory.

e.g. Change

```
roles_path = ~/.rvm/gems/ruby-2.3.1@my-gemset/gems/subspace-0.1.2/ansible/roles:/etc/ansible/roles
```

to

```
roles_path = ~/.rvm/gems/ruby-2.3.1@my-gemset/gems/subspace-0.1.3/ansible/roles:/etc/ansible/roles
```

_This example assumes usage of RVM. The location of your gemsets may be different._

## Usage

* `subspace init`

Initialize the project for subspace. Creates `config/provision` with all
necessary files.

* `rake provision:<environment>`

Runs the playbook at `config/provision/<environment.yml>`.

## Directory Structure

`ansible/roles`

Contains all of our custom roles. When the gem is installed and `subspace init`
is ran, the newly created `ansible.cfg` will be configured to look for these
roles.

`template`

Contains the template files that get copied over when `subspace init` is ran.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tenforwardconsulting/subspace. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).