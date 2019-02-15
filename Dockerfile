FROM jdeathe/centos-ssh:2.5.0

ARG RELEASE_VERSION="2.0.1"

# ------------------------------------------------------------------------------
# Base install of required packages
# ------------------------------------------------------------------------------
RUN yum -y install \
			--setopt=tsflags=nodocs \
			--disableplugin=fastestmirror \
		redis40u-4.0.11-1.ius.centos7  \
	&& yum versionlock add \
		redis40u* \
	&& yum clean all

# ------------------------------------------------------------------------------
# Copy files into place
# ------------------------------------------------------------------------------
ADD src/etc \
	/etc/
ADD src/opt/scmi \
	/opt/scmi/
ADD src/usr \
	/usr/

# ------------------------------------------------------------------------------
# Provisioning
# - Insert placeholders into redis configuration file
# - Replace placeholders with values in systemd service unit template
# - Set permissions
# ------------------------------------------------------------------------------
RUN sed -i -r \
		-e "s~^(logfile ).+$~\1\"\"~" \
		-e "s~^(bind ).+$~\10.0.0.0~" \
		-e "s~^(# *)?(maxmemory ).+$~\2{{REDIS_MAXMEMORY}}~" \
		-e "s~^(# *)?(maxmemory-policy ).+$~\2{{REDIS_MAXMEMORY_POLICY}}~" \
		-e "s~^(# *)?(maxmemory-samples ).+$~\2{{REDIS_MAXMEMORY_SAMPLES}}~" \
		-e "s~^(tcp-backlog ).*$~\1{{REDIS_TCP_BACKLOG}}~" \
		/etc/redis.conf \
	&& sed -i \
		-e "s~{{RELEASE_VERSION}}~${RELEASE_VERSION}~g" \
		/etc/systemd/system/centos-ssh-redis@.service \
	&& chmod 644 \
		/etc/supervisord.d/redis-server-{bootstrap,wrapper}.conf \
	&& chmod 700 \
		/usr/{bin/healthcheck,sbin/redis-server-{bootstrap,wrapper}} \
	&& chmod 750 \
		/usr/sbin/redis-server-wrapper \
	&& chgrp redis \
		/usr/sbin/redis-server-wrapper

EXPOSE 6379

# ------------------------------------------------------------------------------
# Set default environment variables
# ------------------------------------------------------------------------------
ENV REDIS_AUTOSTART_REDIS_BOOTSTRAP="true" \
	REDIS_AUTOSTART_REDIS_WRAPPER="true" \
	REDIS_MAXMEMORY="64mb" \
	REDIS_MAXMEMORY_POLICY="allkeys-lru" \
	REDIS_MAXMEMORY_SAMPLES="5" \
	REDIS_OPTIONS="" \
	REDIS_TCP_BACKLOG="1024" \
	SSH_AUTOSTART_SSHD="false" \
	SSH_AUTOSTART_SSHD_BOOTSTRAP="false"

# ------------------------------------------------------------------------------
# Set image metadata
# ------------------------------------------------------------------------------
LABEL \
	maintainer="James Deathe <james.deathe@gmail.com>" \
	install="docker run \
--rm \
--privileged \
--volume /:/media/root \
jdeathe/centos-ssh-redis:${RELEASE_VERSION} \
/usr/sbin/scmi install \
--chroot=/media/root \
--name=\${NAME} \
--tag=${RELEASE_VERSION}" \
	uninstall="docker run \
--rm \
--privileged \
--volume /:/media/root \
jdeathe/centos-ssh-redis:${RELEASE_VERSION} \
/usr/sbin/scmi uninstall \
--chroot=/media/root \
--name=\${NAME} \
--tag=${RELEASE_VERSION}" \
	org.deathe.name="centos-ssh-redis" \
	org.deathe.version="${RELEASE_VERSION}" \
	org.deathe.release="jdeathe/centos-ssh-redis:${RELEASE_VERSION}" \
	org.deathe.license="MIT" \
	org.deathe.vendor="jdeathe" \
	org.deathe.url="https://github.com/jdeathe/centos-ssh-redis" \
	org.deathe.description="CentOS-7 7.5.1804 x86_64 - Redis 4.0."

HEALTHCHECK \
	--interval=1s \
	--timeout=1s \
	--retries=4 \
	CMD ["/usr/bin/healthcheck"]

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]