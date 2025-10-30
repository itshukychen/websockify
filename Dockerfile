# Build stage - create source distribution
FROM python:3-alpine AS builder

WORKDIR /build

# Install build dependencies
RUN pip install --no-cache-dir setuptools

# Copy only what's needed to build the distribution
COPY setup.py MANIFEST.in README.md COPYING CHANGES.txt ./
COPY websockify/ ./websockify/
COPY rebind ./rebind
COPY rebind.c ./rebind.c

# Build the source distribution
RUN python3 setup.py sdist --dist-dir /dist

# Production stage - install and run
FROM python:3-alpine AS runner

# Install netcat for healthchecks
RUN apk add --no-cache netcat-openbsd

# Install the package from the built distribution
COPY --from=builder /dist/websockify-*.tar.gz /tmp/
RUN python3 -m pip install --no-cache-dir /tmp/websockify-*.tar.gz && \
    rm -rf /tmp/websockify-* /root/.cache

VOLUME /data

EXPOSE 80
EXPOSE 443

WORKDIR /opt/websockify

ENTRYPOINT ["/usr/local/bin/websockify"]
CMD ["--help"]
