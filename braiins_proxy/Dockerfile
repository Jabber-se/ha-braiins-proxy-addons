FROM braiinssystems/farm-proxy:26.02

# Copy Node.js binary directly from official slim image
COPY --from=node:22-slim /usr/local/bin/node /usr/local/bin/node

# Install git and certificates to fetch GUI assets
RUN apt-get update && apt-get install -y git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone latest GUI build and default templates from official Braiins repository
WORKDIR /usr/src/app
RUN H="github.com" && P="braiins/farm-proxy.git" \
    && git clone --depth 1 "https://${H}/${P}" /tmp/fp \
    && cp -r /tmp/fp/gui/build /usr/src/app/build \
    && cp -r /tmp/fp/monitoring /usr/src/app/monitoring \
    && cp -r /tmp/fp/config /usr/src/app/default_config \
    && rm -rf /tmp/fp

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENTRYPOINT []
CMD [ "/run.sh" ]
