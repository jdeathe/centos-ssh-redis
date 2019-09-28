# Change Log

## 1 - centos-6

Summary of release changes.

### 1.2.1 - 2019-09-28

- Deprecate Makefile target `logs-delayed`; replaced with `logsdef`.
- Updates source image to [1.11.1](https://github.com/jdeathe/centos-ssh/releases/tag/1.11.1).
- Updates `test/health_status` helper script with for consistency.
- Updates Makefile target `logs` to accept `[OPTIONS]` (e.g `make -- logs -ft`).
- Updates info/error output for consistency.
- Updates healthcheck failure messages to remove EOL character that is rendered in status response.
- Updates ordering of Tags and respective Dockerfile links in README.md for readability.
- Adds improved test workflow; added `test-setup` target to Makefile.
- Adds Makefile target `logsdef` to handle deferred logs output within a target chain.
- Adds exec proxy function to `redis-server-wrapper` used to pass through nice.
- Adds `/docs` directory for supplementary documentation.
- Fixes validation failure of 0 second --timeout value in `test/health_status`.
- Removes `ENABLE_REDIS_BOOTSTRAP` from docker-compose example configuration.
- Removes `ENABLE_REDIS_WRAPPER` from docker-compose example configuration.

### 1.2.0 - 2019-06-29

- Updates source image to [1.11.0](https://github.com/jdeathe/centos-ssh/releases/tag/1.11.0).
- Updates CHANGELOG.md to simplify maintenance.
- Updates README.md to simplify contents and improve readability.
- Updates README-short.txt to apply to all image variants.
- Updates Dockerfile `org.deathe.description` metadata LABEL for consistency.
- Updates bootstrap and wrapper supervisord configuration to send error log output to stderr.
- Updates bootstrap timer to use UTC date timestamps.
- Updates bootstrap supervisord configuration file/priority to `20-redis-bootstrap.conf`/`20`.
- Updates wrapper supervisord configuration file/priority to `50-redis-wrapper.conf`/`50`.
- Fixes binary paths in systemd unit files; missing changes from last release.
- Fixes docker host connection status check in Makefile.
- Adds missing instruction step to docker-compose example configuration file.
- Adds `inspect`, `reload` and `top` Makefile targets.
- Adds improved `clean` Makefile target; includes exited containers and dangling images.
- Adds lock/state file to wrapper script.
- Adds `SYSTEM_TIMEZONE` handling to Makefile, scmi, systemd unit and docker-compose templates.
- Adds system time zone validation to healthcheck.
- Removes support for long image tags (i.e. centos-6-1.x.x).
- Removes `REDIS_AUTOSTART_REDIS_BOOTSTRAP`, replaced with `ENABLE_REDIS_BOOTSTRAP`.
- Removes `REDIS_AUTOSTART_REDIS_WRAPPER`, replaced with `ENABLE_REDIS_WRAPPER`.

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
