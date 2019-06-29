## Tags and respective `Dockerfile` links

- `centos-7-redis40u`,[`4.1.0`](https://github.com/jdeathe/centos-ssh-redis/tree/4.1.0) [(centos-7-redis40u/Dockerfile)](https://github.com/jdeathe/centos-ssh-redis/blob/centos-7-redis40u/Dockerfile)
- `centos-7`,[`3.1.0`](https://github.com/jdeathe/centos-ssh-redis/tree/3.1.0) [(centos-7/Dockerfile)](https://github.com/jdeathe/centos-ssh-redis/blob/centos-7/Dockerfile)
- `centos-6`,[`1.2.0`](https://github.com/jdeathe/centos-ssh-redis/tree/1.2.0) [(centos-6/Dockerfile)](https://github.com/jdeathe/centos-ssh-redis/blob/centos-6/Dockerfile)

## Overview

This build uses the base image [jdeathe/centos-ssh](https://github.com/jdeathe/centos-ssh) so inherits it's features but with `sshd` disabled by default. [Supervisor](http://supervisord.org/) is used to start the [`redis-server`](https://redis.io/) daemon when a docker container based on this image is run.

### Image variants

- [IUS Redis 4.0 - CentOS-7](https://github.com/jdeathe/centos-ssh-redis/tree/centos-7-redis40u)
- [EPEL Redis 3.2 - CentOS-7](https://github.com/jdeathe/centos-ssh-redis/tree/centos-7)
- [EPEL Redis 3.2 - CentOS-6](https://github.com/jdeathe/centos-ssh-redis/tree/centos-6)

## Quick start

> For production use, it is recommended to select a specific release tag as shown in the examples.

Run up a container named `redis.1` from the docker image `jdeathe/centos-ssh-redis` on port 6379 of your docker host.

```
$ docker run -d \
  --name redis.1 \
  -p 6379:6379/tcp \
  --sysctl "net.core.somaxconn=1024" \
  jdeathe/centos-ssh-redis:3.1.0
```

Verify the named container's process status and health.

```
$ docker ps -a \
	-f "name=redis.1"
```

Verify successful initialisation of the named container.

```
$ docker logs redis.1
```

Verify the status of the `redis-server` service that's running in the named container.

```
$ docker exec -it \
  redis.1 \
  redis-cli info
```

## Instructions

### Running

To run the a docker container from this image you can use the standard docker commands as shown in the example below. Alternatively, there's a [docker-compose](https://github.com/jdeathe/centos-ssh-redis/blob/centos-7-redis40u/docker-compose.yml) example.

For production use, it is recommended to select a specific release tag as shown in the examples.

#### Using environment variables

In the following example the redis-server service is bound to port 6379 of the docker host. Also, the environment variable `REDIS_MAXMEMORY` has been used to set up a 32mb memory based storage instead of the default 64mb.

```
$ docker stop redis.1 && \
  docker rm redis.1 && \
  docker run \
  --detach \
  --name redis.1 \
  --publish 6379:6379/tcp \
  --sysctl "net.core.somaxconn=2048" \
  --sysctl "net.ipv4.ip_local_port_range=1024 65535" \
  --sysctl "net.ipv4.route.flush=1" \
  --env "REDIS_MAXMEMORY=32mb" \
  --env "REDIS_MAXMEMORY_POLICY=allkeys-lru" \
  --env "REDIS_MAXMEMORY_SAMPLES=10" \
  --env "REDIS_OPTIONS=--loglevel verbose" \
  --env "REDIS_TCP_BACKLOG=2048" \
  jdeathe/centos-ssh-redis:3.1.0
```

#### Environment Variables

Environment variables are available, as detailed below, to allow the operator to configure a container on run. Environment variable values cannot be changed after running the container; it's a one-shot type setting. If you need to change a value you have to terminate, (i.e stop and remove), and replace the running container.

##### ENABLE_REDIS_BOOTSTRAP & ENABLE_REDIS_WRAPPER

It may be desirable to prevent the startup of the redis-server-wrapper script. For example, when using an image built from this Dockerfile as the source for another Dockerfile you could disable redis-server from startup by setting `ENABLE_REDIS_WRAPPER` to `false`. The benefit of this is to reduce the number of running processes in the final container. Another use for this would be to make use of the packages installed in the image such as `redis-cli`; effectively making the container a Redis client. The `ENABLE_REDIS_BOOTSTRAP` environment variable is used to prevent the startup of redis-server-boostrap which is required to initialise the configuration file before starting the wrapper.

##### REDIS_MAXMEMORY

Use `REDIS_MAXMEMORY` to set maxmemory; the default is 64 megabytes.

##### REDIS_MAXMEMORY_POLICY

Use `REDIS_MAXMEMORY_POLICY` to set maxmemory_policy; the default is allkeys-lru. This is more suited to cache / session usage than the Redis default of noeviction.

##### REDIS_MAXMEMORY_SAMPLES

Use `REDIS_MAXMEMORY_SAMPLES` to set maxmemory_samples; the default is 5.

##### REDIS_OPTIONS

Use `REDIS_OPTIONS` to set other redis-server options.

##### REDIS_TCP_BACKLOG

Use `REDIS_TCP_BACKLOG` to set tcp_backlog; the default is 1024.
