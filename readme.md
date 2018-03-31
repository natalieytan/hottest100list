# Hottest 100 List
Deployed at:

[https://hottest100list.herokuapp.com/](https://hottest100list.herokuapp.com/)

## Build
Ruby version: 2.4.1

Gems:
```
gem 'activerecord'
gem 'sinatra-activerecord'
gem 'rake'
gem 'pg'

group :development do
  gem 'sqlite3'  
end
```

## About
This web-app was made as a practice to learn the basics of one of ruby's backend frameworks - [Sinatra](http://sinatrarb.com/).

The data from this project was scraped in python from [Wikipedia](https://en.wikipedia.org/wiki/Triple_J_Hottest_100,_2017), video links for each song was retrieved using [Youtube's  data API](https://developers.google.com/youtube/v3/). I have made the data I have retrieved available in this repository (/triplej.json)

For learning, I have documented my process of creating and deploying this app.

## The entire process of creating this app and deploying to heroku

1. Create Gemfile and bundle install
    

    ```
    #Gemfile
    gem 'activerecord'
    gem 'sinatra-activerecord'
    gem 'rake'
    gem 'pg'

    group :development do
    gem 'sqlite3'  
    end
    ```


    Run:

    `bundle install`

2. Create a Rakefile in root directory
    ```
    #Rakefile
    require 'sinatra/activerecord/rake'
    require './app'
    ```

3. Create config/database.yml file

    This sets up SQLite for the development and test environment, and PostgreSQL for production.

    ```
    #config/database.yml
    development:
    adapter: sqlite3
    database: db/development.sqlite
    host: localhost
    pool: 5
    timeout: 5000

    production:
    url: <%= ENV['DATABASE_URL'] %>
    adapter: postgresql
    database: mydb
    host: localhost 
    pool: 5
    timeout: 5000
    ```

4. Crate config/environment.rb

    This specifies the location of the production database on Heroku

    ```
    configure :production do
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

    ActiveRecord::Base.establish_connection(
        :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
        )
    end
    ```

5. Create app.rb

    ```
    #app.rb
    require 'sinatra'
    require 'sinatra/activerecord'
    require './config/environment'
    require './models'
    ```

6. Create migration
    ```
    rake db:create_migration NAME=create_songs_table
    ```

    add code to migration
    ```
    class CreateSongsTable < ActiveRecord::Migration[5.1]
    def change 
        create_table :songs do |t|
        t.integer :year, :rank
        t.string :title, :artist, :country, :videoid, :image, :title_slug, :country_slug, :artist_slug
        t.datetime :created_at
        t.datetime :updated_at
        end
    end
    end
    ```

7. Run migration 
    ```
    bundle exec rake:migrate
    ```

8. Create model
    ```
    #models.rb
    class Song < ActiveRecord::Base
    end
    ```

6. Seed data
    ```
    bundle exec rake:seed
    ```

7. Create routes in app.rb 

    e.g.
    ```
    get '/' do
        @years = Song.select(:year).distinct
        erb :index
    end
    ```

8. Create views 

    e.g. views/index.erb
    ```
    <div class="centrebox">
    <div class="indexbox">
    <h3> Welcome! </h3>
    <p> Hottest 100 List is an unofficial fansite listing <a href="http://www.abc.net.au/triplej/hottest100/17/" target="_blank">Triple J's hottest 100</a> songs through the years. </p>
    <br />
    <h3> Pick a year and go! </h3>
    <form id="indexyearbox" action="/year" method="POST">
    <select id="selected_year" name="selected_year" class="selected_year" required>
    <option disabled selected  value="">Year</option>
    <% @years.each do |year| %>
        <option value="<%= year.year %>"><%= year.year %></option>
    <%end%>
    </select>
    <button type="submit" form="indexyearbox" class="yearbutton" value="Submit">Go!</button>
    </form>
    </div>
    </div>
    ```

    note: templates in sinatra automatically extend from: ``` layout.erb ```

9. Keep static files (css and images) in ```/public``` folder

10. Add Procfile in root folder (to deploy to Heroku)

    This says that you want to run a web process with the command on the port that Heroku gives you, using the bundle environment given. The “rackup” command to find the “config.ru” file should make sense since it is how we start Rack-based frameworks like Sinatra.


    ```
    Procfile
    web: bundle exec rackup config.ru -p $PORT
    ```

11. Create herokuapp & push to heroku

    In top level directory:

    ```heroku create your-app-name```

    ```git push heroku master```

12. Get PostgreSQL addon for heroku

    ```heroku addons:create heroku-postgresql:hobby-dev```

13. Add .env file
    set the environment DATABASE_URL key equal to the response Heroku gave from the previous step e.g.:
    ```
    DATABASE_URL=HEROKU_POSTGRESQL_CRIMSON_URL
    ```

13. Migrate & seed on heroku
    ```
    heroku run rake db:migrate
    heroku run rake db:seed
    ```

14. Save and push to heroku
    ```
    git add .
    git commit -m "Deploy on Heroku"
    git push heroku master
    ```

## Tutorials which helped me
[10 Steps to Heroku - Letting Sinatra Sing in SQLite3 and PostgreSQL](http://agdavid.github.io/2016/05/05/10_steps_to_heroku_letting_your_sinatra_app_sing_in_sqlite3_and_postgresql/)

[Setting up Sinatra Project](https://gist.github.com/jtallant/fd66db19e078809dfe94401a0fc814d2)