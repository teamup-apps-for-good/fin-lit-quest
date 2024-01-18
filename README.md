# Fin*Lit* Quest

## Getting Started with Development

### Setup

```bash
# make sure you have ruby 3.2.2 installed
rbenv install 3.2.2
# clone the application
git clone https://github.com/teamup-apps-for-good/fin-lit-quest.git
# install dependencies
bundle install
# set up database
rails db:create db:reset
```

### Running Tests

Make sure to run the following before creating a pull request; this ensures that it will pass the automated Actions tests.

```bash
bundle exec rspec -fd --fail-fast \
    && bundle exec rails cucumber \
    && bundle exec rubocop --format github \
    && bundle exec rubycritic app lib
```

No specific rubycritic score is required, but the report should be reviewed, and any significant issues addressed.

## Run

Run the website locally by executing

```bash
bin/rails s
```

## Deploying

The deployments are all handled automatially through Github Actions. If you need to deploy to a separate Heroku account follow these steps:

```bash
# first ensure you are logged in with heroku
# then run these commands at the root of the project

# create the app and postgres addon
heroku create -a <new app name>
heroku addons:create heroku-postgresql:mini
# deploy this code to the app
git push heroku main
# finally, seed the initial database
heroku run rake db:seed
```

## Resetting the Databse

If the migration history is changed or breaking database changes are committed, you may need to completely reset the database. You will need the heroku CLI installed.
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

## Contact

If you have any issues with running this application, or want to report a bug, please [create an issue](https://github.com/teamup-apps-for-good/fin-lit-quest/issues/new).

