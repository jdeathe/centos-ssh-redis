centos-ssh-redis
====================

Docker Image including:

- CentOS-6 6.10 x86_64 and Redis 3.2.
- CentOS-7 7.5.1804 x86_64 and Redis 4.0.

## Overview & links

The latest CentOS-6 / CentOS-7 based releases can be pulled from the `centos-6` / `centos-7` Docker tags respectively. For production use it is recommended to select a specific release tag - the convention is `centos-6-1.0.0` OR `1.0.0` for the [1.0.0](https://github.com/jdeathe/centos-ssh-redis/tree/1.0.0) release tag and `centos-7-2.0.0` OR `2.0.0` for the [2.0.0](https://github.com/jdeathe/centos-ssh-redis/tree/2.0.0) release tag.

### Tags and respective `Dockerfile` links

- `centos-7`,`centos-7-2.0.0`,`2.0.0` [(centos-7/Dockerfile)](https://github.com/jdeathe/centos-ssh-redis/blob/centos-7/Dockerfile)
- `centos-6`,`centos-6-1.0.0`,`1.0.0` [(centos-6/Dockerfile)](https://github.com/jdeathe/centos-ssh-redis/blob/centos-6/Dockerfile)

Included in the build are the [SCL](https://www.softwarecollections.org/), [EPEL](http://fedoraproject.org/wiki/EPEL) and [IUS](https://ius.io) repositories. Installed packages include [OpenSSH](http://www.openssh.com/portable.html) secure shell, [vim-minimal](http://www.vim.org/), are installed along with python-setuptools, [supervisor](http://supervisord.org/) and [supervisor-stdout](https://github.com/coderanger/supervisor-stdout).

Supervisor is used to start the redis-server (and optionally the sshd) daemon when a docker container based on this image is run. To enable simple viewing of stdout for the service's subprocess, supervisor-stdout is included. This allows you to see output from the supervisord controlled subprocesses with `docker logs {docker-container-name}`.

If enabling and configuring SSH access, it is by public key authentication and, by default, the [Vagrant](http://www.vagrantup.com/) [insecure private key](https://github.com/mitchellh/vagrant/blob/master/keys/vagrant) is required.

### SSH Alternatives

SSH is not required in order to access a terminal for the running container. The simplest method is to use the docker exec command to run bash (or sh) as follows: 

```
$ docker exec -it {docker-name-or-id} bash
```

For cases where access to docker exec is not possible the preferred method is to use Command Keys and the nsenter command.

## Quick Example

Run up a container named `redis.pool-1.1.1` from the docker image `jdeathe/centos-ssh-redis` on port 6379 of your docker host.

```
$ docker run -d \
  --name redis.pool-1.1.1 \
  -p 6379:6379/tcp \
  --sysctl "net.core.somaxconn=1024" \
  jdeathe/centos-ssh-redis:2.0.0
```

Now you can verify it is initialised and running successfully by inspecting the container's logs.

```
$ docker logs redis.pool-1.1.1
```

## Instructions

### Running

To run the a docker container from this image you can use the standard docker commands. Alternatively, if you have a checkout of the [source repository](https://github.com/jdeathe/centos-ssh-redis), and have make installed the Makefile provides targets to build, install, start, stop etc. where environment variables can be used to configure the container options and set custom docker run parameters.

In the following example the redis-server service is bound to port 6379 of the docker host. Also, the environment variable `REDIS_MAXMEMORY` has been used to set up a 32mb memory based storage instead of the default 64mb.

#### Using environment variables

```
$ docker stop redis.pool-1.1.1 && \
  docker rm redis.pool-1.1.1
$ docker run \
  --detach \
  --name redis.pool-1.1.1 \
  --publish 6379:6379/tcp \
  --env "REDIS_MAXMEMORY=32mb" \
  --env "REDIS_MAXMEMORY_POLICY=allkeys-lru" \
  --env "REDIS_MAXMEMORY_SAMPLES=10" \
  --env "REDIS_OPTIONS=--loglevel verbose" \
  --env "REDIS_TCP_BACKLOG=2048" \
  --sysctl "net.core.somaxconn=2048" \
  --sysctl "net.ipv4.ip_local_port_range=1024 65535" \
  --sysctl "net.ipv4.route.flush=1" \
  jdeathe/centos-ssh-redis:2.0.0
```

#### Environment Variables

There are environmental variables available which allows the operator to customise the running container.

##### REDIS_AUTOSTART_REDIS_BOOTSTRAP & REDIS_AUTOSTART_REDIS_WRAPPER

It may be desirable to prevent the startup of the redis-server-wrapper script. For example, when using an image built from this Dockerfile as the source for another Dockerfile you could disable redis-server from startup by setting `REDIS_AUTOSTART_REDIS_WRAPPER` to `false`. The benefit of this is to reduce the number of running processes in the final container. Another use for this would be to make use of the packages installed in the image such as `redis-cli`; effectively making the container a Redis client. The `REDIS_AUTOSTART_REDIS_BOOTSTRAP` environment variable is used to prevent the startup of redis-server-boostrap which is required to initialise the configuration file before starting the wrapper.

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
