# Change Log

## centos-6

Summary of release changes for Version 1.

CentOS-6 6.10 x86_64 - Redis 3.2.

### 1.1.0 - Unreleased

- Updates source image to [1.10.0](https://github.com/jdeathe/centos-ssh/releases/tag/1.10.0).
- Updates and restructures Dockerfile.
- Updates default HEALTHCHECK interval to 1 second from 0.5.
- Updates container naming conventions and readability of `Makefile`.
- Fixes issue with unexpected published port in run templates when `DOCKER_PORT_MAP_TCP_6379` or `DOCKER_PORT_MAP_UDP_6379` is set to an empty string or 0.
- Adds placeholder replacement of `RELEASE_VERSION` docker argument to systemd service unit template.
- Adds consideration for event lag into test cases for unhealthy health_status events.
- Adds port incrementation to Makefile's run template for container names with an instance suffix.
- Removes use of `/etc/services-config` paths.
- Removes X-Fleet section from etcd register template unit-file.
- Removes the unused group element from the default container name.
- Removes the node element from the default container name.

### 1.0.1 - 2018-11-19

- Updates source image to [1.9.1](https://github.com/jdeathe/centos-ssh/releases/tag/1.9.1).

### 1.0.0 - 2018-11-03

- Initial release.
