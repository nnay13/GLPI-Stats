# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_glpi_session',
  :secret      => 'c03b6e1de03791009a71ac3639431b480a8e3fb8ad29caad757120b81a6ad89c1eea2b69b6b30489a6321a220ddff6ac2aa02b4cbf1468b7f02623c59d35173d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
