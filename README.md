blckbstr
===================
Don't you have a clue which movie to watch next? Fill in your or multiple Letterboxd users and we will give you custom advice.


Installation
-------------------

    bundle install

We use Bower for our front-end packages:

    bundle exec rake bower:install

Open 'config/secrets.yml.example' and save this file as 'config/secrets.yml'. In order to generate secret tokens use the following command:

    bundle exec rake secret

We use Figaro for our environment variables. Open 'config/application.yml.example' and save this file as 'config/application.yml'. Make sure the variables inside have the correct values.

Then you're good to go:

    bundle exec rails s

If you use Sublime Text there's an example file of our used project settings. Save this as a new file without .example.