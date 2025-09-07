ARG BUILD_FROM
FROM $BUILD_FROM

# Install bashio
RUN curl -L -s -o /tmp/bashio.tar.gz "https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio*

# Install dependencies
RUN apk add --no-cache \
    ruby \
    ruby-dev \
    ruby-bundler \
    build-base \
    git \
    sqlite-dev \
    nodejs \
    yarn \
    tzdata \
    bash \
    curl \
    jq \
    openssl

# Set working directory
WORKDIR /app

# Clone Campfire source code
RUN git clone https://github.com/basecamp/once-campfire.git /app

# Install Ruby gems
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

# Install Node.js dependencies and build assets
RUN yarn install --frozen-lockfile && \
    yarn build

# Create necessary directories
RUN mkdir -p /app/tmp/pids /app/log /app/storage

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Set proper permissions
RUN chown -R root:root /app

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/up || exit 1

CMD [ "/run.sh" ]