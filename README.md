# one day this will be better

Install docker and then:
bundle exec rails services:up && bundle exec rails s

Creds:
VISUAL="code --wait" bundle exec rails credentials:edit

before deploying you should run:
bundle exec rails test

To view logs:
heroku logs -n 10000
heroku logs -n 10000 --ps worker

To deploy:
git push heroku main

To run Pry:
bundle exec pry -r ./config/environment

Or Rails Console on Heroku:
heroku run rails console