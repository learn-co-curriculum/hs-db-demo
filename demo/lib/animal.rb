require_relative 'jungle.rb'

class Animal < ActiveRecord::Base
  belongs_to :jungle

end