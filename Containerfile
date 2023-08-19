FROM debian:latest

RUN apt-get update
RUN apt-get install --assume-yes \
  imagemagick \
  wget \
  zip

COPY split.sh /
RUN chmod +x /split.sh
WORKDIR /data
ENTRYPOINT ["/split.sh"]
