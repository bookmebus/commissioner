# SpreeCmCommissioner

![Commission gem build status](https://github.com/channainfo/commissioner/actions/workflows/publish.yml/badge.svg?branch= "Build status")

An application platform built on top of Spree commerce for modeling any bussiness applications.

## Installation

1; Add this extension to your Gemfile with this line:

```ruby
gem 'spree_cm_commissioner'
```

2; Install the gem using Bundler

```ruby
bundle install
```

3; Copy & run migrations

```ruby
bundle exec rails g spree_cm_commissioner:install
```

4; Restart your server

If your server was running, restart it so that it can find the assets properly.

## Config

### Rake tasks

```sh
# Seed province data for Cambodia country
rake data:seed_kh_provinces

# Seed option values and type location
rake data:seed_kh_location_option_values

# Reindex Elasticsearch on Vendor model
rake searchkick:reindex CLASS=Spree::Vendor
```

### Google Map

CM commissioner required Google Map key for [map components](app/views/shared/map/_map.html.erb).

```env
# .env
GOOGLE_MAP_KEY = ""
DEFAULT_LATLON = "10.627543,103.522141"
```

<!-- * Describe new config usage above -->
<!-- * Also put in summary at the last section [All environments] below -->

### Elasticsearch

Commissioner required elasticsearch version 8.5.2. We recommend using [evm](https://github.com/duydo/evm) to manage their version.

1, Install EVM (Elasticsearch Version Manager):

```sh
sudo curl -o /usr/local/bin/evm https://raw.githubusercontent.com/duydo/evm/master/evm
sudo chmod +x /usr/local/bin/evm
```

2, Install elasticsearch

```sh
evm install 8.5.2

# To start elasticsearch
evm start

# To stop elasticsearch
evm stop
```

### Visual Studio Code Editor && Rubocop

- Install VScode Extensions: **ruby-rubocop**

- Make sure have below settings in VScode User Settings. It will auto-correct with rubocop after save file

```json
{
  "ruby.rubocop.executePath": "/Users/USER_NAME/.rbenv/shims/"
}
```

- We can run auto correction

```sh
#  Autocorrect offenses (only when it's safe)
$ bundle exec rubocop -a # or bundle exec rubocop --auto-correct

# Autocorrect offenses (safe and unsafe).
$ bundle exec rubocop -A # or bundle exec rubocop --auto-correct-all
```

### All environments

Following are required varialbles inside .env

```env
GOOGLE_MAP_KEY = ""
DEFAULT_LATLON = "10.627543,103.522141"
ACCOMMODATION_MAX_STAY_DAYS = 10
DEFAULT_TELEGRAM_BOT_API_TOKEN = ""

PIN_CODE_DEBUG_NOTIFIY_TELEGRAM_ENABLE="yes"
RECAPTCHA_TOKEN_VALIDATOR_ENABLE="yes"

EXCEPTION_NOTIFY_ENABLE="yes" # yes or no
EXCEPTION_TELEGRAM_BOT_TOKEN=""
EXCEPTION_NOTIFIER_TELEGRAM_CHANNEL_ID=""
```

## Using Deface DSL (.deface files)

- Make sure the path of override should match the path of view template
- The .deface can be use with :erb, :html, or :text

Example:

```sh
View Template file: app/views/spree/admin/vendors/_form
Override file: app/overrides/spree/admin/vendors/_form/logo.html.erb.deface
```

<https://github.com/spree/deface#using-the-deface-dsl-deface-files>

## Schedule Jobs

- Create a schedule to update vendor min and max price
- Frequently: every 24 hours
- Run time: mid night is preferable
- Command: `rake "spree_cm_commissioner:vendor_update_price_range"`
- Customer_notification

````yml
customer_notification:
  cron: '0 0 * * * *'   # will trigger every hour, every day of the month, every month, and every day of the week
  class: SpreeCmCommissioner::CustomerNotificationCron
````

## Testing

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `rake test_app`.

```sh
bundle update
bundle exec rake test_app
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'spree_cm_commissioner/factories'
```

## Releasing

```sh
bundle exec gem bump -p -t
bundle exec gem release
```

For more options please see [gem-release REAMDE](https://github.com/svenfuchs/gem-release)

## Contributing

If you'd like to contribute, please take a look at the
[instructions](CONTRIBUTING.md) for installing dependencies and crafting a good
pull request.

Copyright (c) 2022 [name of extension creator], released under the New BSD License

### Account Deletion Cron Job

- **AccountDeletionCronJob**
- Frequently: every 24 hours
- Deleted Account will last for 1 month before it is permanently deleted

### Multiple databases

In most cases, Rails is able to infer the database connection. However in some instances, for example, in the spree_backend gem, it uses the GET request
to destroy the session which in turn triggers database update that require the writing role. To fix this we need to explicitly tell Rails to use the right database connection.

Error using a wrong database connection looks like this:

```rb
raise ActiveRecord::ReadOnlyError, "Write query attempted while in readonly mode: #{sql}"
```

An ActiveRecord::ReadOnlyError occurred in orders#new.

```ruby
module SpreeCmCommissioner
  module Admin
    module UserSessionsControllerDecorator
      def self.prepended(base)
        # spree_devise_auth gem use get as destroy
        # get '/logout' => 'user_sessions#destroy', :as => :logout
        base.around_action :set_writing_role, only: %i[destroy]
      end
    end
  end
end

unless Spree::Admin::UserSessionsController.ancestors.include?(SpreeCmCommissioner::Admin::UserSessionsControllerDecorator)
  Spree::Admin::UserSessionsController.prepend(SpreeCmCommissioner::Admin::UserSessionsControllerDecorator)
end

```
