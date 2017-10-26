FROM alpine:latest

MAINTAINER support@opsani.com

RUN apk add --update --no-cache jq

COPY entrypoint.sh /entrypoint.sh

# Use 'exec' form to prevent an extra 'sh -c' invocation (this eats up the arg
# list)
ENTRYPOINT ["/entrypoint.sh"]
