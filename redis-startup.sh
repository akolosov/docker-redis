#!/bin/bash

if [ -n "$REDIS_MASTER_SERVER" ]; then
	redis-server /etc/redis/redis.conf $*
fi

if [ -n "$REDIS_CUSTOM_MASTER_SERVER" ]; then
	redis-server $REDIS_CUSTOM_MASTER_SERVER $*
fi

if [ -n "$REDIS_SLAVE_SERVER" ]; then
	redis-server /etc/redis/redis.conf --slaveof $REDIS_SLAVE_SERVER $*
fi

if [ -n "$REDIS_CUSTOM_SLAVE_SERVER" ]; then
	if [ -n "$REDIS_SLAVE_SERVER_FOR" ]; then
		redis-server $REDIS_CUSTOM_SLAVE_SERVER --slaveof $REDIS_SLAVE_SERVER_FOR $*
	else
		redis-server $REDIS_CUSTOM_SLAVE_SERVER $*
	fi
fi

if [ -n "$REDIS_SENTNEL_SERVER" ]; then
	redis-sentinel /etc/redis/sentinel.conf $*
fi

if [ -n "$REDIS_CUSTOM_SENTNEL_SERVER" ]; then
	redis-sentinel $REDIS_CUSTOM_SENTNEL_SERVER $* 
fi

