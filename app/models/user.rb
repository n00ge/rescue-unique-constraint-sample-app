class User < ApplicationRecord
  include RescueUniqueConstraint
  rescue_unique_constraint index: :index_users_on_email,
                           field: :email

  has_one :profile, inverse_of: :user
end
