---
tags: kids, databases, db, activerecord, sinatra
languages: ruby
type: demo
level: 3
---

##Persisting Data

By now you should have an awesome application that can create instances of a class and display them in the browser. But every time the page is reloaded, or a new user uses the page, those instances are lost. We can't persist (save) information yet. That's where databases come in. A database is just like an excel spreadsheet with columns that store different pieces of information. If we had a Person class that had name, height, and age attributes, our database would have a table called persons with three different columns, one for each attribute.


###ORM
Programming uses lots of acronyms. ORM stands for object relational mapping. We've gotten really good at creating classes, and then instances of those classes. We've even played around with interactions between objects in two different classes, like when we built the jungle or the Sim City project. These relationships between classes become really really important when you're setting up a database.

We'll be working with three different types of relationships between objects:

* has_many
* has_one
* belongs_to

The two relationships you'll deal with the most frequently are `has_many` and `belongs_to`. Let's take our jungle that we built earlier in the semester and build out our Jungle class and Animal class with these types of relationships.

When we originally built the jungle, there was no clear stated relationship between our Jungle class and our Animal class. We as humans are able to associate that jungle with the animals, and we created methods within our Jungle class to see all the animals, create new animals, etc. But, never once did we declare within the code that the Jungle class was at all related to the Animal class. You can read the code and make that assumption, but that's not at all a best practice. We want our code to be as clear and readable as possible. 

So how can we make these relationships clear? How can we actually state that the jungle has animals, and animals live inside the jungle?


###ActiveRecord

ActiveRecord is the answer to all of our problems. ActiveRecord is a gem that allows us to establish relationships between classes and is the liaison between the code and the database. ActiveRecord is a DSL (domain specific language) so that we can write Ruby methods to save information to our database and pull information from the database.

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

```ruby
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

```ruby
task :wake_up do
  puts "WAKE UP!!!!!"
end
```

In order to use these rake tasks we need to set up a Rakefile in our project. Create a Rakefile with `touch Rakefile` in terminal. We'll need to add these lines of code to the Rakefile:

```ruby
require "./app"
require "sinatra/activerecord/rake"
```

To see all the rake tasks available type `rake -T` in terminal. Let's create our jungles table with the following rake task in the terminal: `rake db:create_migration NAME=create_jungles`.

This rake task will create a folder called `migrate` and a file in that folder that starts with a time stamp and the value of `NAME` that you passed in. Inside of this file you'll see a `def change` method. Instead of this method we're going to create two methods `up` and `down`. The `up` method is used to actually create the table in the database. The `down` method is only called if you want to delete that table.

We want our jungle to have the attributes size, name, location and rainfall, so we'll need to create those columns in this table. Inside the `up` method we need to add this code to create a jungles table:

```ruby
  create_table :jungles do |t|
    t.string  :size
    t.string  :name
    t.string  :location
    t.integer :rainfall
  end
```

We are calling an ActiveRecord method `create_table` to create the table with the name jungles. We are iterating through the table to create columns using the variable `t` to represent each column.  The first thing we have to do is state the data type for the column. Each column can only contain one specific type of data. If you declare a column to hold a string it will store all the data as strings. Following the data type is the name of the column in symbol form. One column that we don't see here, that gets added automatically to the table is an ID column. Each row of our database table will have it's own unique ID number.

Lastly we need to create the `down` method like this:

```ruby
  def down
    drop_table :posts
  end
```

This migration file defines what our table is going to look like but it doesn't actually create the table. To do that we need to use this command in our terminal: `rake db:migrate`. This will execute the up method in our `migration` and create a table with the columns that we've specified.


###Using our databases

Let's practice by creating an instance of our Jungle class. We do this the same way we always have like this:

```ruby
amazon = Jungle.new
amazon.name = "Amazon"
amazon.location = "Brazil"
amazon.save!
```

At this point our `Jungle` class has only one line `has_many :animals`. We haven't defined any reader or writer methods or attribute accessors. So how can we do `name=`? This is a method provided by ActiveRecord. It acts similar to a write method, by assigning a name value to an instance of the Jungle class. It also does one more important thing, when we call `amazon.save!` it adds this value to the name column in the jungles table. For this reason, we can no longer use `attr_accessor`. 

###
Now let's add an animals tables. We can do this the same way that we added the jungles table but there is one important column that we need to add, a `jungle_id` column. The `has_many` and `belongs_to` associations that we set up in our Jungle and Animal classes will help us set up the relationships between these objects, but they will not work properly without this `jungle_id` column. 

Let's set up a new Jungle and a new Animal:

```ruby
amazon = Jungle.new
amazon.name = "Amazon"
amazon.location = "Brazil"
amazon.save!

puma = Animal.new
puma.name = "Puma"
puma.save!
```
Jungle Table:

|id | name| location
|--- |--- |---
| 1 | "Amazon" | "Brazil"

Animal Table:
|  id | name | jungle_id
|--- |--- |---
| 1 | "Puma"| nil


If we wanted to make sure that Puma is associated with the Amazon we can make the connection this way:

```ruby
puma.jungle_id = amazon.id
```

When we created `amazon` it was automatically assigned a unique ID number.


ActiveRecord provides us with the method `jungle_id=` and we use it to assign

There is one important column that we need to add to the 



