#!/bin/bash

cp /etc/redis/redis_defaul.conf /etc/redis/redis.conf

if [ "$REDIS_MODE" == "LRU" ]; then
	echo "=> Configuring redis as a LRU cache"
	MAXMEMORY=${REDIS_MAXMEMORY:-"256mb"}
	echo "maxmemory $MAXMEMORY" >> /etc/redis/redis.conf
	echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
fi

# Close the connection after a client is idle for N seconds (0 to disable)
TIMEOUT=${REDIS_TIMEOUT:-"0"}
echo "=> Setting timeout to ${TIMEOUT}"
echo timeout ${TIMEOUT} >> /etc/redis/redis.conf

if [ -n "$REDIS_MASTER_SERVER" ]; then
	/usr/local/bin/redis-server /etc/redis/redis.conf $@
fi

if [ -n "$REDIS_SLAVE_SERVER" ]; then
	/usr/local/bin/redis-server /etc/redis/redis.conf --slaveof $REDIS_SLAVE_SERVER $@
fi

if [ -n "$REDIS_SENTINEL_SERVER" ]; then
	[ -z "$REDIS_MASTER_IP" ] && export REDIS_MASTER_IP="127.0.0.1"
	sed -i "s/^\(sentinel monitor master \)\(\_MASTER\_IP\_\)\(.*\)$/\1$REDIS_MASTER_IP\3/" /etc/redis/sentinel.conf

	/usr/local/bin/redis-sentinel /etc/redis/sentinel.conf $@
fi

if [ -n "$REDIS_CLIENT" ]; then
	/usr/local/bin/redis-cli $@
fi

