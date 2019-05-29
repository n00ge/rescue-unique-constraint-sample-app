class Profile < ApplicationRecord
  include RescueUniqueConstraint
  belongs_to :user, optional: true, inverse_of: :profile

  # rescue_unique_constraint index: :index_profiles_on_user_id,
  #                          field: :user_id

  rescue_unique_constraint index: :index_profiles_on_street_and_zip,
                           field: :street
end
