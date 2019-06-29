# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
readonly DOCKER_IMAGE_NAME=centos-ssh-redis
readonly DOCKER_IMAGE_RELEASE_TAG_PATTERN='^[1,3-4]\.[0-9]+\.[0-9]+$'
readonly DOCKER_IMAGE_TAG_PATTERN='^(latest|[1,3-4]\.[0-9]+\.[0-9]+)$'
readonly DOCKER_USER=jdeathe

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
DIST_PATH="${DIST_PATH:-./dist}"
DOCKER_CONTAINER_OPTS="${DOCKER_CONTAINER_OPTS:-}"
DOCKER_IMAGE_TAG="${DOCKER_IMAGE_TAG:-latest}"
DOCKER_NAME="${DOCKER_NAME:-redis.1}"
DOCKER_PORT_MAP_TCP_6379="${DOCKER_PORT_MAP_TCP_6379:-6379}"
DOCKER_PORT_MAP_UDP_6379="${DOCKER_PORT_MAP_UDP_6379:-NULL}"
DOCKER_RESTART_POLICY="${DOCKER_RESTART_POLICY:-always}"
NO_CACHE="${NO_CACHE:-false}"
REGISTER_ETCD_PARAMETERS="${REGISTER_ETCD_PARAMETERS:-}"
REGISTER_TTL="${REGISTER_TTL:-60}"
REGISTER_UPDATE_INTERVAL="${REGISTER_UPDATE_INTERVAL:-55}"
STARTUP_TIME="${STARTUP_TIME:-1}"
SYSCTL_NET_CORE_SOMAXCONN="${SYSCTL_NET_CORE_SOMAXCONN:-1024}"
SYSCTL_NET_IPV4_IP_LOCAL_PORT_RANGE="${SYSCTL_NET_IPV4_IP_LOCAL_PORT_RANGE:-1024 65535}"
SYSCTL_NET_IPV4_ROUTE_FLUSH="${SYSCTL_NET_IPV4_ROUTE_FLUSH:-1}"

# ------------------------------------------------------------------------------
# Application container configuration
# ------------------------------------------------------------------------------
ENABLE_REDIS_BOOTSTRAP="${ENABLE_REDIS_BOOTSTRAP:-true}"
ENABLE_REDIS_WRAPPER="${ENABLE_REDIS_WRAPPER:-true}"
REDIS_MAXMEMORY="${REDIS_MAXMEMORY:-64mb}"
REDIS_MAXMEMORY_POLICY="${REDIS_MAXMEMORY_POLICY:-allkeys-lru}"
REDIS_MAXMEMORY_SAMPLES="${REDIS_MAXMEMORY_SAMPLES:-5}"
REDIS_OPTIONS="${REDIS_OPTIONS:-}"
REDIS_TCP_BACKLOG="${REDIS_TCP_BACKLOG:-1024}"
SYSTEM_TIMEZONE="${SYSTEM_TIMEZONE:-UTC}"
