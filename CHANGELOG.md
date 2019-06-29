# Change Log

## 4 - centos-7-redis40u

Summary of release changes.

### 4.1.0 - 2019-06-29

- Updates source image to [2.6.0](https://github.com/jdeathe/centos-ssh/releases/tag/2.6.0).
- Updates `redis40u` packages to 4.0.14-1.
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
- Removes support for long image tags (i.e. centos-7-redis40u-4.x.x).
- Removes `REDIS_AUTOSTART_REDIS_BOOTSTRAP`, replaced with `ENABLE_REDIS_BOOTSTRAP`.
- Removes `REDIS_AUTOSTART_REDIS_WRAPPER`, replaced with `ENABLE_REDIS_WRAPPER`.

### 4.0.0 - 2019-03-22

- Initial release.
