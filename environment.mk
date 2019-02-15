# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
DOCKER_USER := jdeathe
DOCKER_IMAGE_NAME := centos-ssh-redis
SHPEC_ROOT := test/shpec

# Tag validation patterns
DOCKER_IMAGE_TAG_PATTERN := ^(latest|centos-[6-7]|((1|2|centos-(6-1|7-2))\.[0-9]+\.[0-9]+))$
DOCKER_IMAGE_RELEASE_TAG_PATTERN := ^(1|2|centos-(6-1|7-2))\.[0-9]+\.[0-9]+$

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

# Docker --sysctl settings
SYSCTL_NET_CORE_SOMAXCONN ?= 1024
SYSCTL_NET_IPV4_IP_LOCAL_PORT_RANGE ?= 1024 65535
SYSCTL_NET_IPV4_ROUTE_FLUSH ?= 1

# Docker image/container settings
DOCKER_CONTAINER_OPTS ?=
DOCKER_IMAGE_TAG ?= latest
DOCKER_NAME ?= redis.1
DOCKER_PORT_MAP_TCP_6379 ?= 6379
DOCKER_PORT_MAP_UDP_6379 ?= NULL
DOCKER_RESTART_POLICY ?= always

# Docker build --no-cache parameter
NO_CACHE ?= false

# Directory path for release packages
DIST_PATH ?= ./dist

# Number of seconds expected to complete container startup including bootstrap.
STARTUP_TIME ?= 2

# ------------------------------------------------------------------------------
# Application container configuration
# ------------------------------------------------------------------------------
REDIS_AUTOSTART_REDIS_BOOTSTRAP ?= true
REDIS_AUTOSTART_REDIS_WRAPPER ?= true
REDIS_MAXMEMORY ?= 64mb
REDIS_MAXMEMORY_POLICY ?= allkeys-lru
REDIS_MAXMEMORY_SAMPLES ?= 5
REDIS_OPTIONS ?=
REDIS_TCP_BACKLOG ?= 1024
