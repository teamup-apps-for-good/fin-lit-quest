# Fin*Lit* Quest

## Setup

```bash
# make sure you have ruby 3.2.2 installed
rbenv install 3.2.2
# install dependencies
bundle install
# set up database
rails db:create db:reset
```

## Testing

Make sure to run the following before creating a pull request; this ensures that it will pass the automated Actions tests.

```bash
bundle exec rspec -fd --fail-fast \
    && bundle exec rails cucumber \
    && bundle exec rubocop --format github \
    && bundle exec rubycritic app lib
```

