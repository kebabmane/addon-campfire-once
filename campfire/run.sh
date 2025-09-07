#!/usr/bin/with-contenv bashio

set -e

CONFIG_PATH=/data/options.json

# Parse configuration
DOMAIN=$(bashio::config 'domain')
SSL=$(bashio::config 'ssl')
CERTFILE=$(bashio::config 'certfile')
KEYFILE=$(bashio::config 'keyfile')
ADMIN_PASSWORD=$(bashio::config 'admin_password')
SECRET_KEY_BASE=$(bashio::config 'secret_key_base')
DATABASE_URL=$(bashio::config 'database_url')

# Set default values
if [ -z "$DOMAIN" ]; then
    DOMAIN="localhost"
fi

if [ -z "$SECRET_KEY_BASE" ]; then
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    bashio::log.warning "No SECRET_KEY_BASE configured. Generated: $SECRET_KEY_BASE"
fi

if [ -z "$DATABASE_URL" ]; then
    DATABASE_URL="sqlite3:///data/campfire.sqlite3"
fi

# Configure environment
export RAILS_ENV=production
export SECRET_KEY_BASE="$SECRET_KEY_BASE"
export DATABASE_URL="$DATABASE_URL"
export CAMPFIRE_DOMAIN="$DOMAIN"

# SSL Configuration
# For Home Assistant ingress, SSL is handled by the proxy, so we disable force_ssl in Rails
export RAILS_FORCE_SSL="false"
bashio::log.info "SSL termination handled by Home Assistant ingress proxy"

if bashio::var.true "${SSL}"; then
    export CAMPFIRE_SSL="true"
    if bashio::fs.file_exists "/ssl/${CERTFILE}"; then
        export SSL_CERT_PATH="/ssl/${CERTFILE}"
        export SSL_KEY_PATH="/ssl/${KEYFILE}"
        bashio::log.info "SSL certificates found but not used (ingress handles SSL)"
    else
        bashio::log.info "SSL enabled in config but certificates not needed (ingress handles SSL)"
    fi
else
    export CAMPFIRE_SSL="false"
fi

# Admin password
if [ -n "$ADMIN_PASSWORD" ]; then
    export CAMPFIRE_ADMIN_PASSWORD="$ADMIN_PASSWORD"
fi

# Change to app directory
cd /app

# Setup database
bashio::log.info "Setting up database..."
if [ ! -f "/data/campfire.sqlite3" ]; then
    bundle exec rails db:setup
else
    bundle exec rails db:migrate
fi

# Create admin user if password is provided
if [ -n "$ADMIN_PASSWORD" ]; then
    bashio::log.info "Creating/updating admin user..."
    bundle exec rails runner "
      admin = User.find_or_initialize_by(email_address: 'admin@${DOMAIN}')
      admin.password = '${ADMIN_PASSWORD}'
      admin.name = 'Admin'
      admin.save!
      puts 'Admin user created/updated'
    " || bashio::log.warning "Could not create admin user"
fi

# Start the application
bashio::log.info "Starting Campfire..."
exec bundle exec rails server -b 0.0.0.0 -p 3000