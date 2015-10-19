To configure sentinel.conf at run-time

`docker run akolosov/docker-redis --[config A] --[config B]`

Important: the you must bind ports (-p) and set the (sentinel announce-ip) and (sentinel-announce-port) parameters in sentinel.conf for Sentinel to work in a container environment.

Here's an example of what that looks like:

`docker run -p 26379:26379 akolosov/docker-redis --sentinel announce-ip 1.2.3.4 --sentinel announce-port 26379`