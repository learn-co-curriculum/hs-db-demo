require 'bundler'
Bundler.require
require_relative 'lib/jungle.rb'
require_relative 'lib/animal.rb'

set :database, "sqlite3:jungle.db"

class MyApp < Sinatra::Base

  get '/' do 
    "hello world!"
  end

end