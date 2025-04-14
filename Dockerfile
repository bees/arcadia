FROM rust:1.86-slim-bullseye
WORKDIR /app
COPY . .

RUN if [ ! -f ".env" ]; then \
    echo "No custom .env file found, using default env"; \
    cp .env.example .env; \
fi

RUN apt-get update && apt-get install -y postgresql postgresql-client libssl-dev openssl curl pkg-config

RUN SQLX_OFFLINE=true cargo build --release

# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/app/target/release/arcadia"]
