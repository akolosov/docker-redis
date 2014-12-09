FROM dockerfile/ubuntu

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
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/db/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1\nlogfile \/data\/log\/redis.log/' /etc/redis/redis.conf

# Define mountable directories
VOLUME ["/data/logs", "/data/db"]

# Define working directory
WORKDIR /data

RUN mkdir -p /data/db
RUN mkdir -p /data/logs

# Define entrypoint
ENTRYPOINT ["redis-sentinel", "/etc/redis/sentinel.conf"]

# Expose ports
EXPOSE 26379