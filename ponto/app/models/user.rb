class User < ActiveRecord::Base
  belongs_to :employee

  devise :database_authenticatable, :validatable
end
