# Work in progress

## Prerequisites:
  - VirtualBox
  - Vagrant (with utils module)
  - An Heroku account

## Test
```bash
# Clone the repo
git clone https://github.com/mtancoigne/heroku-cakephp3-app.git heroku-cakephp3-app
cd heroku-cakephp3-app

# Create the box
vagrant up

# test the box, going to http://localhost:8080 or http://192.168.56.101.

# Log on the box:
vagrant ssh

# Navigate to the site sources
cd /vagrant

# Login to heroku
heroku login

# Create a heroku app:
heroku create

# Push the site:
git push heroku master
# Optionnal: enable postgreSQL on Heroku:
heroku addons:create heroku-postgresql:hobby-dev

# Test the heroku box :
heroku open <name-of-the-heroku-app>
```
That's all for now, but tests are coming (DB migrations, etc...)
