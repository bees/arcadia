FROM rust:1.86-slim-bookworm AS prebuild
# Don't delete any downloaded packages, we'd be using BuildKit cache mounts later!
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

WORKDIR /app

# This doesn't mount anything from your system, it's all in the build cache
# Helps speed up repetitive docker builds by A LOT
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y libssl-dev openssl curl pkg-config

COPY . .

RUN SQLX_OFFLINE=true cargo build --release

CMD ["./arcadia-index"]