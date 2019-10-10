# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
DOCKER_IMAGE_NAME := centos-ssh-redis
DOCKER_IMAGE_RELEASE_TAG_PATTERN := ^[1,3-5]\.[0-9]+\.[0-9]+$
DOCKER_IMAGE_TAG_PATTERN := ^(latest|[1,3-5]\.[0-9]+\.[0-9]+)$
DOCKER_USER := jdeathe
SHPEC_ROOT := test/shpec

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
DIST_PATH ?= ./dist
DOCKER_CONTAINER_OPTS ?=
DOCKER_IMAGE_TAG ?= latest
DOCKER_NAME ?= redis.1
DOCKER_PORT_MAP_TCP_6379 ?= 6379
DOCKER_PORT_MAP_UDP_6379 ?= NULL
DOCKER_RESTART_POLICY ?= always
NO_CACHE ?= false
RELOAD_SIGNAL ?= HUP
STARTUP_TIME ?= 1
SYSCTL_NET_CORE_SOMAXCONN ?= 1024
SYSCTL_NET_IPV4_IP_LOCAL_PORT_RANGE ?= 1024 65535
SYSCTL_NET_IPV4_ROUTE_FLUSH ?= 1

# ------------------------------------------------------------------------------
# Application container configuration
# ------------------------------------------------------------------------------
ENABLE_REDIS_BOOTSTRAP ?= true
ENABLE_REDIS_WRAPPER ?= true
REDIS_MAXMEMORY ?= 64mb
REDIS_MAXMEMORY_POLICY ?= allkeys-lru
REDIS_MAXMEMORY_SAMPLES ?= 5
REDIS_OPTIONS ?=
REDIS_TCP_BACKLOG ?= 1024
SYSTEM_TIMEZONE ?= UTC
