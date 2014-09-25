---
tags: kids, databases, db, activerecord, sinatra
languages: ruby
type: demo
level: 3
---


##Persisting Data

By now you should have an awesome application that can create instances of a class and display them in the browser. But every time a the page is reloaded, or a new user users the page, those instances are lost. We can persist (save) information. That's where databases come in. A database is just like an excel spreadsheet with columns that store different pieces of information. If we had a Person class that had name, height, and age attributes, our database would have a table called persons that has three different columns, one for each attribute.


###ORM:
Programming uses lots of acronyms. ORM stands for object relational mapping. We've gotten really good at creating classes, and then instances of those classes. We've even played around with interactions between objects in two different classes, like when we built the jungle or the Sim City project. These relationships between classes becomes really really important when you're setting up a data.

There are three different types of relationships between objects:

* has_many
* has_one
* belongs_to


The two relationships you'll deal with the most frequenly are `has_many` and `belongs_to`. Let's take our jungle that we built earlier in the semester and build out our Jungle class and Animal class with these types of relationships.

When we originally built the jungle, there was no clear stated relationship between our Jungle class and our Animal class. We as humans are able to associate that jungle with the animals, and we created methods within our Jungle class to see all the animals, create new animals, etc. But, never once did we declare within the code that the Jungle class was at all related to the Animal class. You can read the code and make that assumption, but that's not at all a best practice. We want our code to be as clear and readable as possible. 

So how can we make these relationships clear? How can we actually state that the jungle has animals, and animals live inside the jungle?


###ActiveRecord

ActiveRecord is the answer to all of our problems. ActiveRecord is a gem that allows us to establish relationships between classes and is the liason between the code and the database. ActiveRecord is a DSL (domain specific language) so that we can write Ruby methods to save information to our database and pull information from the database.

ActiveRecord also allows us to declare specific relationships between classes. Using ActiveRecord, we can explicitly declare a relationship between our Jungle class and our Animal class:


```ruby
class Jungle
  has_many :animals
end

class Animal
  belongs_to :jungle
end
```

These relationships become incredibly important when we want to pull information from our database.


###Databases

We're going to be using a SQLite3 database, which is a collection of tables. Each table corresponds to a model in our application. In the case of the jungle, we have two models (Jungle and Animal), so we would have two tables one named `jungles` and one named `animals`. The naming convention is important to note. Our class names are **always** singular, but our table names are **always** plural. `class Jungle` relates to table `jungles`. 

In order to create a database, we need to do a few pieces of setup.

In our `Gemfile`, we need to make sure we include the following:

```
  gem "sqlite3"
  gem "activerecord"
  gem "sinatra-activerecord"
  gem "rake"
```

In `app.rb`, we need to set up a connection to our database: `set :database, "sqlite3:name_of_database.db"`. This line is telling our application to connect to a database with a specific name. Until this application is hosted on a server, your local database will just be a file saved in the directory of your application with the file extension `db`. You do have to manually create the database file. 

In terminal, enter `touch name_of_database.rb`. You'll want to name your database something related to the topic of your application. In the case of the jungle application, you could name your database `jungle.db`. If you had an application that told you the weather, you could have `weather.db`. It's important to note that name of the database is not the same thing as a the name of a table. A database can have an infinite number of tables.

Lastly, we need to create a `db` directory, which will contain all of the code to create specific tables. In terminal: `mkdir db`.


###Creating A Table:

Now that we know we want to have two tables, we need to actually create them. ActiveRecord uses something called migrations (paired with rake tasks) to create the tables.

A rake task is a ruby implementation of something called Make, which automatically builds executable programs from the source code. Ruby uses Rake, and we write our tasks in `Rakefile`.You can read more about Rake [here](http://jasonseifer.com/2010/04/06/rake-tutorial).

A rake task is basically a method with a little bit of a different syntax. Instead of writing `def` to signify the start of the method, we write `task`. The method name starts with a colon. Let's say we wanted to write a rake task to set off an alarm to wake us up every morning. It would look something like this:

```
task :wake_up do
  puts "WAKE UP!!!!!"
end
```






what sql is -- sqlite3 databse




db directory
