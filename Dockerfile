FROM alpine:3.20

LABEL maintainer="StrawberryGecko <dev@strawberrygecko.net>"

# Install cron + git
RUN apk add --no-cache git bash curl tini busybox-suid

# Copy backup script
COPY command.sh /usr/local/bin/command.sh
RUN chmod +x /usr/local/bin/command.sh

# Add crontab
COPY crontab /etc/crontabs/root

# Use tini as entrypoint for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]

CMD ["crond", "-f", "-L", "/dev/stdout"]
