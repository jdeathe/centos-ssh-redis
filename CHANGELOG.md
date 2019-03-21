# Change Log

## centos-6

Summary of release changes for Version 1.

CentOS-6 6.10 x86_64 - Redis 3.2.

### 1.1.1 - 2019-03-21

- Updates source image to [1.10.1](https://github.com/jdeathe/centos-ssh/releases/tag/1.10.1).
- Updates Redis package to `redis-3.2.12-2` from the EPEL repository.
- Updates Dockerfile with combined ADD to reduce layer count in final image.
- Fixes binary paths in systemd unit files for compatibility with both EL and Ubuntu hosts.
- Adds improvement to pull logic in systemd unit install template.
- Adds `SSH_AUTOSTART_SUPERVISOR_STDOUT` with a value "false", disabling startup of `supervisor_stdout`.
- Adds improved `healtchcheck` script.
- Adds `docker-compose.yml` to `.dockerignore`.
- Disables disk persistence by default; primary use-case being an LRU cache.

### 1.1.0 - 2019-02-17

- Updates source image to [1.10.0](https://github.com/jdeathe/centos-ssh/releases/tag/1.10.0).
- Updates and restructures Dockerfile.
- Updates default HEALTHCHECK interval to 1 second from 0.5.
- Updates container naming conventions and readability of `Makefile`.
- Fixes issue with unexpected published port in run templates when `DOCKER_PORT_MAP_TCP_6379` or `DOCKER_PORT_MAP_UDP_6379` is set to an empty string or 0.
- Adds placeholder replacement of `RELEASE_VERSION` docker argument to systemd service unit template.
- Adds consideration for event lag into test cases for unhealthy health_status events.
- Adds port incrementation to Makefile's run template for container names with an instance suffix.
- Adds docker-compose configuration example.
- Adds improved logging output.
- Adds improved bootstrap / wrapper scripts.
- Removes use of `/etc/services-config` paths.
- Removes X-Fleet section from etcd register template unit-file.
- Removes the unused group element from the default container name.
- Removes the node element from the default container name.
- Removes unused environment variables from Makefile and scmi configuration.
- Removes container log file `/var/log/redis-server-bootstrap` and `/var/log/redis/redis.log`.

### 1.0.1 - 2018-11-19

- Updates source image to [1.9.1](https://github.com/jdeathe/centos-ssh/releases/tag/1.9.1).

### 1.0.0 - 2018-11-03

- Initial release.
