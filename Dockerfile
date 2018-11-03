# =============================================================================
# jdeathe/centos-ssh-redis
#
# CentOS-6, Redis 3.2.
# =============================================================================
FROM jdeathe/centos-ssh:1.9.0

RUN yum -y install \
			--setopt=tsflags=nodocs \
			--disableplugin=fastestmirror \
		redis32u-3.2.12-1.ius.centos6 \
	&& yum versionlock add \
		redis32u* \
	&& yum clean all

# -----------------------------------------------------------------------------
# Copy files into place
# -----------------------------------------------------------------------------
ADD src/usr/bin \
	/usr/bin/
ADD src/usr/sbin \
	/usr/sbin/
ADD src/opt/scmi \
	/opt/scmi/
ADD src/etc/services-config/supervisor/supervisord.d \
	/etc/services-config/supervisor/supervisord.d/
ADD src/etc/systemd/system \
	/etc/systemd/system/

RUN ln -sf \
		/etc/services-config/supervisor/supervisord.d/redis-server-bootstrap.conf \
		/etc/supervisord.d/redis-server-bootstrap.conf \
	&& ln -sf \
		/etc/services-config/supervisor/supervisord.d/redis-server-wrapper.conf \
		/etc/supervisord.d/redis-server-wrapper.conf \
	&& chmod 700 \
		/usr/{bin/healthcheck,sbin/redis-server-{bootstrap,wrapper}} \
	&& chmod 750 \
		/usr/sbin/redis-server-wrapper \
	&& chgrp redis \
		/usr/sbin/redis-server-wrapper \
	&& sed -i -r \
		-e "s~^(logfile ).+$~\1\"\"~" \
		-e "s~^(bind ).+$~\10.0.0.0~" \
		-e "s~^(# *)?(maxmemory ).+$~\2{{REDIS_MAXMEMORY}}~" \
		-e "s~^(# *)?(maxmemory-policy ).+$~\2{{REDIS_MAXMEMORY_POLICY}}~" \
		-e "s~^(# *)?(maxmemory-samples ).+$~\2{{REDIS_MAXMEMORY_SAMPLES}}~" \
		-e "s~^(tcp-backlog ).*$~\1{{REDIS_TCP_BACKLOG}}~" \
		/etc/redis.conf

EXPOSE 6379

# -----------------------------------------------------------------------------
# Set default environment variables
# -----------------------------------------------------------------------------
ENV REDIS_AUTOSTART_REDIS_BOOTSTRAP="true" \
	REDIS_AUTOSTART_REDIS_WRAPPER="true" \
	REDIS_MAXMEMORY="64mb" \
	REDIS_MAXMEMORY_POLICY="allkeys-lru" \
	REDIS_MAXMEMORY_SAMPLES="5" \
	REDIS_OPTIONS="" \
	REDIS_TCP_BACKLOG="1024" \
	SSH_AUTOSTART_SSHD="false" \
	SSH_AUTOSTART_SSHD_BOOTSTRAP="false"

# -----------------------------------------------------------------------------
# Set image metadata
# -----------------------------------------------------------------------------
ARG RELEASE_VERSION="1.0.0"
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
	org.deathe.description="CentOS-6 6.10 x86_64 - Redis 3.2."

HEALTHCHECK \
	--interval=0.5s \
	--timeout=1s \
	--retries=4 \
	CMD ["/usr/bin/healthcheck"]

CMD ["/usr/bin/supervisord", "--configuration=/etc/supervisord.conf"]