# Fin*Lit* Quest

[![Maintainability](https://api.codeclimate.com/v1/badges/64e9303e74f63d75ecf9/maintainability)](https://codeclimate.com/github/teamup-apps-for-good/fin-lit-quest/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/64e9303e74f63d75ecf9/test_coverage)](https://codeclimate.com/github/teamup-apps-for-good/fin-lit-quest/test_coverage)

## Getting Started with Development

### Setup

First, install `rbenv` for managing ruby versions. Then, run the following commands to set up the development environment.

```bash
# make sure you have ruby 3.2.2 installed
rbenv install 3.2.2
# clone the application
git clone https://github.com/teamup-apps-for-good/fin-lit-quest.git
cd fin-lit-quest
# install dependencies
bundle config set without 'production'
bundle install
# set up credentials store
# This requires you to have the master key
echo <CREDENTIAL_STORE_MASTER_KEY> > config/master.key
# set up database
bundle exec rails db:create db:migrate db:reset
```

### Auth
1. Create an OAuth consent screen for this project in Google Cloud with the scopes userinfo.email and userinfo.name
2. Create a client ID and secret for this consent screen on Google Cloud
3. Delete the `config/credentials.yml.enc` file
4. Create a new file and master key by running `EDITOR=nano rails credentials:edit`
5. In this file, place the following content, replacing client_id and client_secret with your details generated in step 2. Also, take note of the secret_key_base in this file if deploying to heroku
```
google:
    client_id: client_id
    client_secret: client_secret
```
6. Take note of the contents of the `config/master.key` file if deploying to heroku

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
heroku addons:create heroku-postgresql:mini -a <your app name>
# deploy this code to the app
git push heroku main
# seed the initial database
heroku run rake db:seed -a <your app name>
# add the environment variables for oauth
# see the auth step under getting started with development above to obtain these values
heroku config:set RAILS_MASTER_KEY=<your master key> SECRET_KEY_BASE=<your secret key base>
```

You will also need to configure the proper environment variables, such as the key to the credential store.

## Resetting the Database

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

If you have any issues with running this application, or want to provide any feedback, please [create an issue](https://github.com/teamup-apps-for-good/fin-lit-quest/issues/new).

