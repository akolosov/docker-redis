FROM akolosov/ubuntu

# Install dependencies
RUN apt-get update
RUN apt-get upgrade -yqq
RUN apt-get -yqq install make gcc tar
RUN apt-get -yqq clean
RUN rm -rf /var/lib/apt/lists/*

# Install Redis
RUN \
  cd /tmp && \
  curl -O http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  rm -rf /tmp/redis-stable*

ADD sentinel.conf /etc/redis/sentinel.conf
ADD redis.conf /etc/redis/redis_default.conf
ADD redis-startup.sh /usr/local/bin/redis-startup.sh

RUN chmod 755 /usr/local/bin/redis-startup.sh

# Define mountable directories
VOLUME ["/data/logs", "/data/db"]

# Define working directory
WORKDIR /data

RUN mkdir -p /data/db
RUN mkdir -p /data/logs

# Define entrypoint
ENTRYPOINT ["/bin/bash", "/usr/local/bin/redis-startup.sh"]

# Expose ports
EXPOSE 26379 6379
