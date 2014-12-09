#!/bin/bash

sysctl vm.overcommit_memory=1

if [ -n "$REDIS_MASTER_SERVER" ]; then
	exec /usr/local/bin/redis-server /etc/redis/redis.conf $@
fi

if [ -n "$REDIS_CUSTOM_MASTER_SERVER" ]; then
	exec /usr/local/bin/redis-server $REDIS_CUSTOM_MASTER_SERVER $@
fi

if [ -n "$REDIS_SLAVE_SERVER" ]; then
	exec /usr/local/bin/redis-server /etc/redis/redis.conf --slaveof $REDIS_SLAVE_SERVER $@
fi

if [ -n "$REDIS_CUSTOM_SLAVE_SERVER" ]; then
	if [ -n "$REDIS_SLAVE_SERVER_FOR" ]; then
		exec /usr/local/bin/redis-server $REDIS_CUSTOM_SLAVE_SERVER --slaveof $REDIS_SLAVE_SERVER_FOR $@
	else
		exec /usr/local/bin/redis-server $REDIS_CUSTOM_SLAVE_SERVER $@
	fi
fi

if [ -n "$REDIS_SENTNEL_SERVER" ]; then
	exec /usr/local/bin/redis-sentinel /etc/redis/sentinel.conf $@
fi

if [ -n "$REDIS_CUSTOM_SENTNEL_SERVER" ]; then
	exec /usr/local/bin/redis-sentinel $REDIS_CUSTOM_SENTNEL_SERVER $@ 
fi

if [ -n "$REDIS_CLIENT" ]; then
	exec /bin/bash $@
fi

