
# Handle incrementing the docker host port for instances unless a port range is defined.
DOCKER_PUBLISH := $(shell \
	if [[ "$(DOCKER_PORT_MAP_TCP_6379)" != NULL ]]; \
	then \
		if grep -qE \
				'^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:)?[1-9][0-9]*$$' \
				<<< "$(DOCKER_PORT_MAP_TCP_6379)" \
			&& grep -qE \
				'^.+\.[0-9]+(\.[0-9]+)?$$' \
				<<< "$(DOCKER_NAME)"; \
		then \
			printf -- ' --publish %s%s:6379/tcp' \
				"$$(\
					grep -o '^[0-9\.]*:' \
						<<< "$(DOCKER_PORT_MAP_TCP_6379)" \
				)" \
				"$$(( \
					$$(\
						grep -oE \
							'[0-9]+$$' \
							<<< "$(DOCKER_PORT_MAP_TCP_6379)" \
					) \
					+ $$(\
						grep -oE \
							'([0-9]+)(\.[0-9]+)?$$' \
							<<< "$(DOCKER_NAME)" \
						| awk -F. \
							'{ print $$1; }' \
					) \
					- 1 \
				))"; \
		else \
			printf -- ' --publish %s:6379/tcp' \
				"$(DOCKER_PORT_MAP_TCP_6379)"; \
		fi; \
	fi; \
	if [[ "$(DOCKER_PORT_MAP_UDP_6379)" != NULL ]]; \
	then \
		if grep -qE \
				'^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:)?[1-9][0-9]*$$' \
				<<< "$(DOCKER_PORT_MAP_UDP_6379)" \
			&& grep -qE \
				'^.+\.[0-9]+(\.[0-9]+)?$$' \
				<<< "$(DOCKER_NAME)"; \
		then \
			printf -- ' --publish %s%s:6379/udp' \
				"$$(\
					grep -o '^[0-9\.]*:' \
						<<< "$(DOCKER_PORT_MAP_UDP_6379)" \
				)" \
				"$$(( \
					$$(\
						grep -oE \
							'[0-9]+$$' \
							<<< "$(DOCKER_PORT_MAP_UDP_6379)" \
					) \
					+ $$(\
						grep -oE \
							'([0-9]+)(\.[0-9]+)?$$' \
							<<< "$(DOCKER_NAME)" \
						| awk -F. \
							'{ print $$1; }' \
					) \
					- 1 \
				))"; \
		else \
			printf -- ' --publish %s:6379/udp' \
				"$(DOCKER_PORT_MAP_UDP_6379)"; \
		fi; \
	fi; \
)

# Common parameters of create and run targets
define DOCKER_CONTAINER_PARAMETERS
--name $(DOCKER_NAME) \
--restart $(DOCKER_RESTART_POLICY) \
--sysctl "net.core.somaxconn=$(SYSCTL_NET_CORE_SOMAXCONN)" \
--sysctl "net.ipv4.ip_local_port_range=$(SYSCTL_NET_IPV4_IP_LOCAL_PORT_RANGE)" \
--sysctl "net.ipv4.route.flush=$(SYSCTL_NET_IPV4_ROUTE_FLUSH)" \
--env "ENABLE_REDIS_BOOTSTRAP=$(ENABLE_REDIS_BOOTSTRAP)" \
--env "ENABLE_REDIS_WRAPPER=$(ENABLE_REDIS_WRAPPER)" \
--env "REDIS_MAXMEMORY=$(REDIS_MAXMEMORY)" \
--env "REDIS_MAXMEMORY_POLICY=$(REDIS_MAXMEMORY_POLICY)" \
--env "REDIS_MAXMEMORY_SAMPLES=$(REDIS_MAXMEMORY_SAMPLES)" \
--env "REDIS_OPTIONS=$(REDIS_OPTIONS)" \
--env "REDIS_TCP_BACKLOG=$(REDIS_TCP_BACKLOG)" \
--env "SYSTEM_TIMEZONE=$(SYSTEM_TIMEZONE)"
endef
