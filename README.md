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

## Run

Run the website locally by executing

```bash
bin/rails s
```

## Resetting the Databse
If the migration history is changed or breaking database changes are committed, you may need to completely database. You will need the heroku CLI installed.
Warning, this will **erase all data**
1. Run `rake db:drop:all` to completely destroy the database
2. Run `rake db:create` to recreate it
3. Run `rake db:migrate` to rebuild it
4. Run `rake db:seed` to reseed it.

### Doing this on Heroku
If you need to do this on Heroku, you still probably shouldn't. ***This will destroy all production data***.

1. Go to the database on Heroku -> settings -> Reset Database. This will completely reset the database to a fresh Postgres install.
2. Run `heroku run rake db:create`
3. Run `heroku run rake db:migrate`
4. Run `heroku run rake db:seed`
