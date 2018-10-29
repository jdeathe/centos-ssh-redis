# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
readonly SERVICE_UNIT_ENVIRONMENT_KEYS="
 DOCKER_CONTAINER_OPTS
 DOCKER_IMAGE_PACKAGE_PATH
 DOCKER_IMAGE_TAG
 DOCKER_PORT_MAP_TCP_6379
 DOCKER_PORT_MAP_UDP_6379
 REDIS_AUTOSTART_REDIS_BOOTSTRAP
 REDIS_AUTOSTART_REDIS_WRAPPER
 REDIS_MAXMEMORY
 REDIS_MAXMEMORY_POLICY
 REDIS_MAXMEMORY_SAMPLES
 REDIS_OPTIONS
 REDIS_TCP_BACKLOG
"
readonly SERVICE_UNIT_REGISTER_ENVIRONMENT_KEYS="
 REGISTER_ETCD_PARAMETERS
 REGISTER_TTL
 REGISTER_UPDATE_INTERVAL
"

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------
SERVICE_UNIT_INSTALL_TIMEOUT=${SERVICE_UNIT_INSTALL_TIMEOUT:-4}
