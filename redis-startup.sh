#!/bin/bash

if [ -n "$REDIS_MASTER_SERVER" ]; then
	/usr/local/bin/redis-server /etc/redis/redis.conf $@
fi

if [ -n "$REDIS_CUSTOM_MASTER_SERVER" ]; then
	/usr/local/bin/redis-server $REDIS_CUSTOM_MASTER_SERVER $@
fi

if [ -n "$REDIS_SLAVE_SERVER" ]; then
	/usr/local/bin/redis-server /etc/redis/redis.conf --slaveof $REDIS_SLAVE_SERVER $@
fi

if [ -n "$REDIS_CUSTOM_SLAVE_SERVER" ]; then
	if [ -n "$REDIS_SLAVE_SERVER_FOR" ]; then
		/usr/local/bin/redis-server $REDIS_CUSTOM_SLAVE_SERVER --slaveof $REDIS_SLAVE_SERVER_FOR $@
	else
		/usr/local/bin/redis-server $REDIS_CUSTOM_SLAVE_SERVER $@
	fi
fi

if [ -n "$REDIS_SENTINEL_SERVER" ]; then
	/usr/local/bin/redis-sentinel /etc/redis/sentinel.conf $@
fi

if [ -n "$REDIS_CUSTOM_SENTINEL_SERVER" ]; then
	/usr/local/bin/redis-sentinel $REDIS_CUSTOM_SENTINEL_SERVER $@ 
fi

if [ -n "$REDIS_CLIENT" ]; then
	/usr/local/bin/redis-cli $@
fi

