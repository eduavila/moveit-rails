class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_many :entries
end
