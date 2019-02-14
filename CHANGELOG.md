# Change Log

## centos-7

Summary of release changes for Version 2.

CentOS-7 7.5.1804 x86_64 - Redis 4.0.

### 2.1.0 - Unreleased

- Updates source image to [2.5.0](https://github.com/jdeathe/centos-ssh/releases/tag/2.5.0).
- Updates and restructures Dockerfile.
- Updates default HEALTHCHECK interval to 1 second from 0.5.
- Adds placeholder replacement of `RELEASE_VERSION` docker argument to systemd service unit template.
- Removes use of `/etc/services-config` paths.
- Removes X-Fleet section from etcd register template unit-file.

### 2.0.1 - 2018-11-19

- Updates source image to [2.4.1](https://github.com/jdeathe/centos-ssh/releases/tag/2.4.1).

### 2.0.0 - 2018-11-03

- Initial release.
