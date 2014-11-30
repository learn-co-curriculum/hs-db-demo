require_relative 'animal.rb'

class Jungle < ActiveRecord::Base
  has_many :animals
  
end