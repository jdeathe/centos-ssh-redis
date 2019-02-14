readonly STARTUP_TIME=2
readonly TEST_DIRECTORY="test"

# These should ideally be a static value but hosts might be using this port so 
# need to allow for alternatives.
DOCKER_PORT_MAP_TCP_22="${DOCKER_PORT_MAP_TCP_22:-NULL}"
DOCKER_PORT_MAP_TCP_6379="${DOCKER_PORT_MAP_TCP_6379:-6379}"

function __destroy ()
{
	local -r private_network_1="bridge_internal_1"

	if [[ -n $(docker network ls -q -f name="${private_network_1}") ]]
	then
		docker network rm \
			${private_network_1} \
		&> /dev/null
	fi
}

function __get_container_port ()
{
	local container="${1:-}"
	local port="${2:-}"
	local value=""

	value="$(
		docker port \
			${container} \
			${port}
	)"
	value=${value##*:}

	printf -- \
		'%s' \
		"${value}"
}

# container - Docker container name.
# counter - Timeout counter in seconds.
# process_pattern - Regular expression pattern used to match running process.
# ready_test - Command used to test if the service is ready.
function __is_container_ready ()
{
	local container="${1:-}"
	local counter=$(
		awk \
			-v seconds="${2:-10}" \
			'BEGIN { print 10 * seconds; }'
	)
	local process_pattern="${3:-}"
	local ready_test="${4:-true}"

	until (( counter == 0 ))
	do
		sleep 0.1

		if docker exec ${container} \
			bash -c "ps axo command \
				| grep -qE \"${process_pattern}\" \
				&& eval \"${ready_test}\"" \
			&> /dev/null
		then
			break
		fi

		(( counter -= 1 ))
	done

	if (( counter == 0 ))
	then
		return 1
	fi

	return 0
}

function __setup ()
{
	local -r private_network_1="bridge_internal_1"

	if [[ -z $(docker network ls -q -f name="${private_network_1}") ]]
	then
		docker network create \
			--internal \
			--driver bridge \
			--gateway 172.172.40.1 \
			--subnet 172.172.40.0/24 \
			${private_network_1} \
		&> /dev/null
	fi
}

# Custom shpec matcher
# Match a string with an Extended Regular Expression pattern.
function __shpec_matcher_egrep ()
{
	local pattern="${2:-}"
	local string="${1:-}"

	printf -- \
		'%s' \
		"${string}" \
	| grep -qE -- \
		"${pattern}" \
		-

	assert equal \
		"${?}" \
		0
}

function __terminate_container ()
{
	local container="${1}"

	if docker ps -aq \
		--filter "name=${container}" \
		--filter "status=paused" &> /dev/null
	then
		docker unpause ${container} &> /dev/null
	fi

	if docker ps -aq \
		--filter "name=${container}" \
		--filter "status=running" &> /dev/null
	then
		docker stop ${container} &> /dev/null
	fi

	if docker ps -aq \
		--filter "name=${container}" &> /dev/null
	then
		docker rm -vf ${container} &> /dev/null
	fi
}

function test_basic_operations ()
{
	local container_port_6379=""
	local settings_value=""

	trap "__terminate_container redis.pool-1.1.1 &> /dev/null; \
		__destroy; \
		exit 1" \
		INT TERM EXIT

	describe "Basic Redis operations"
		describe "Runs named container"
			__terminate_container \
				redis.pool-1.1.1 \
			&> /dev/null

			it "Can publish ${DOCKER_PORT_MAP_TCP_6379}:6379."
				docker run \
					--detach \
					--name redis.pool-1.1.1 \
					--publish ${DOCKER_PORT_MAP_TCP_6379}:6379 \
					jdeathe/centos-ssh-redis:latest \
				&> /dev/null

				container_port_6379="$(
					__get_container_port \
						redis.pool-1.1.1 \
						6379/tcp
				)"

				if [[ ${DOCKER_PORT_MAP_TCP_6379} == 0 ]] \
					|| [[ -z ${DOCKER_PORT_MAP_TCP_6379} ]]
				then
					assert gt \
						"${container_port_6379}" \
						"30000"
				else
					assert equal \
						"${container_port_6379}" \
						"${DOCKER_PORT_MAP_TCP_6379}"
				fi
			end
		end

		if ! __is_container_ready \
			redis.pool-1.1.1 \
			${STARTUP_TIME} \
			"/usr/bin/redis " \
			"redis-cli \
				-h 127.0.0.1 \
				-p 6379 \
				PING \
			| grep -qP \
				'^PONG$'"
		then
			exit 1
		fi

		describe "Default initialisation"
   
			it "Sets bind=0.0.0.0."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get bind \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					0.0.0.0
			end

			it "Sets maxmemory=67108864."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					67108864
			end

			it "Sets maxmemory-policy=allkeys-lru."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory-policy \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					allkeys-lru
			end

			it "Sets maxmemory-samples=5."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory-samples \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					5
			end

			it "Sets tcp-backlog=1024."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get tcp-backlog \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					1024
			end

		end

		__terminate_container \
			redis.pool-1.1.1 \
		&> /dev/null
	end

	trap - \
		INT TERM EXIT
}

function test_custom_configuration ()
{
	local -r private_network_1="bridge_internal_1"
	local -r test_data_input="$(< test/fixtures/lorem-ipsum-base64.txt)"
	local container_port_6379=""
	local settings_value=""
	local test_data_output=""

	trap "__terminate_container redis.pool-1.1.1 &> /dev/null; \
		__terminate_container redis.pool-1.1.2 &> /dev/null; \
		__destroy; \
		exit 1" \
		INT TERM EXIT

	describe "Customised Redis configuration"
		describe "Runs named container"
			__terminate_container \
				redis.pool-1.1.1 \
			&> /dev/null

			it "Can publish ${DOCKER_PORT_MAP_TCP_6379}:6379."
				docker run \
					--detach \
					--name redis.pool-1.1.1 \
					--publish ${DOCKER_PORT_MAP_TCP_6379}:6379 \
					--env "REDIS_MAXMEMORY=32mb" \
					--env "REDIS_MAXMEMORY_POLICY=noeviction" \
					--env "REDIS_MAXMEMORY_SAMPLES=10" \
					--env "REDIS_OPTIONS=--loglevel verbose" \
					--env "REDIS_TCP_BACKLOG=2048" \
					jdeathe/centos-ssh-redis:latest \
				&> /dev/null

				container_port_6379="$(
					__get_container_port \
						redis.pool-1.1.1 \
						6379/tcp
				)"

				if [[ ${DOCKER_PORT_MAP_TCP_6379} == 0 ]] \
					|| [[ -z ${DOCKER_PORT_MAP_TCP_6379} ]]
				then
					assert gt \
						"${container_port_6379}" \
						"30000"
				else
					assert equal \
						"${container_port_6379}" \
						"${DOCKER_PORT_MAP_TCP_6379}"
				fi
			end
		end

		if ! __is_container_ready \
			redis.pool-1.1.1 \
			${STARTUP_TIME} \
			"/usr/bin/redis " \
			"redis-cli \
				-h 127.0.0.1 \
				-p 6379 \
				PING \
			| grep -qP \
				'^PONG$'"
		then
			exit 1
		fi

		describe "Custom initialisation"

			it "Sets maxmemory=33554432."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					33554432
			end

			it "Sets maxmemory-policy=noeviction."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory-policy \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					noeviction
			end

			it "Sets maxmemory-samples=10."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get maxmemory-samples \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					10
			end

			it "Sets tcp-backlog=2048."
				settings_value="$(
					docker exec \
						redis.pool-1.1.1 \
						redis-cli \
							config get tcp-backlog \
					| tail -n 1 \
					| tr -d '\r'
				)"

				assert equal \
					"${settings_value}" \
					2048
			end
		end

		describe "Runs on a private network."
			__terminate_container \
				redis.pool-1.1.1 \
			&> /dev/null

			__terminate_container \
				redis.pool-1.1.2 \
			&> /dev/null

			it "Runs a named server container"
				docker run \
					--detach \
					--name redis.pool-1.1.1 \
					--network-alias redis.pool-1.1.1 \
					--network ${private_network_1} \
					jdeathe/centos-ssh-redis:latest \
				&> /dev/null

				assert equal \
					"${?}" \
					0
			end

			it "Runs a named client container"
				docker run \
					--detach \
					--name redis.pool-1.1.2 \
					--network-alias redis.pool-1.1.2 \
					--network ${private_network_1} \
					--env REDIS_AUTOSTART_REDIS_WRAPPER=false \
					jdeathe/centos-ssh-redis:latest \
				&> /dev/null

				assert equal \
					"${?}" \
					0
			end

			if ! __is_container_ready \
				redis.pool-1.1.1 \
				${STARTUP_TIME} \
				"/usr/bin/redis " \
				"redis-cli \
					PING \
				| grep -qP \
					'^PONG$'"
			then
				exit 1
			fi

			if ! __is_container_ready \
				redis.pool-1.1.2 \
				${STARTUP_TIME} \
				"/usr/bin/python /usr/bin/supervisord"
			then
				exit 1
			fi

			describe "Redis usage"
				it "Can set data"
					docker cp \
						test/fixtures/lorem-ipsum-base64.txt \
						redis.pool-1.1.2:/tmp/lorem-ipsum-base64.txt

					docker exec \
						redis.pool-1.1.2 \
						bash -c "redis-cli \
							-h redis.pool-1.1.1 \
							-p 6379 \
							-x set lorem-ipsum-base64.txt \
							</tmp/lorem-ipsum-base64.txt" \
					&> /dev/null

					assert equal \
						"${?}" \
						0
				end

				it "Can get data"
					test_data_output="$(
						docker exec \
							redis.pool-1.1.2 \
							bash -c "redis-cli \
								-h redis.pool-1.1.1 \
								-p 6379 \
								get lorem-ipsum-base64.txt"
					)"
				
					assert equal \
						"${test_data_output}" \
						"${test_data_input}"
				end

				it "Can flush data"
					docker exec \
						redis.pool-1.1.2 \
						redis-cli \
							-h redis.pool-1.1.1 \
							-p 6379 \
							flushall \
					&> /dev/null

					test_data_output="$(
						docker exec \
							redis.pool-1.1.2 \
							bash -c "redis-cli \
								-h redis.pool-1.1.1 \
								-p 6379 \
								get lorem-ipsum-base64.txt"
					)"

					assert equal \
						"${test_data_output}" \
						""
				end
			end
		end

		__terminate_container \
			redis.pool-1.1.1 \
		&> /dev/null

		__terminate_container \
			redis.pool-1.1.2 \
		&> /dev/null
	end

	describe "Configure autostart"
		__terminate_container \
			redis.pool-1.1.1 \
		&> /dev/null

		docker run \
			--detach \
			--name redis.pool-1.1.1 \
			--env REDIS_AUTOSTART_REDIS_WRAPPER=false \
			jdeathe/centos-ssh-redis:latest \
		&> /dev/null

		sleep ${STARTUP_TIME}

		it "Can disable redis-server-wrapper."
			docker ps \
				--filter "name=redis.pool-1.1.1" \
				--filter "health=healthy" \
			&> /dev/null \
			&& docker top \
				redis.pool-1.1.1 \
			| grep -qE '/usr/bin/redis '

			assert equal \
				"${?}" \
				"1"
		end

		__terminate_container \
			redis.pool-1.1.1 \
		&> /dev/null

		docker run \
			--detach \
			--name redis.pool-1.1.1 \
			--env REDIS_AUTOSTART_REDIS_BOOTSTRAP=false \
			jdeathe/centos-ssh-redis:latest \
		&> /dev/null

		sleep ${STARTUP_TIME}

		it "Can disable redis-server-bootstrap."
			docker ps \
				--filter "name=redis.pool-1.1.1" \
				--filter "health=healthy" \
			&> /dev/null \
			&& docker exec \
				redis.pool-1.1.1 \
				grep -q '^maxmemory-policy {{REDIS_MAXMEMORY_POLICY}}$' \
				/etc/redis.conf

			assert equal \
				"${?}" \
				"0"
		end

		__terminate_container \
			redis.pool-1.1.1 \
		&> /dev/null
	end

	trap - \
		INT TERM EXIT
}

function test_healthcheck ()
{
	local -r interval_seconds=1
	local -r retries=4
	local health_status=""

	trap "__terminate_container redis.pool-1.1.1 &> /dev/null; \
		__destroy; \
		exit 1" \
		INT TERM EXIT

	describe "Healthcheck"
		describe "Default configuration"
			__terminate_container \
				redis.pool-1.1.1 \
			&> /dev/null

			docker run \
				--detach \
				--name redis.pool-1.1.1 \
				jdeathe/centos-ssh-redis:latest \
			&> /dev/null

			it "Returns a valid status on starting."
				health_status="$(
					docker inspect \
						--format='{{json .State.Health.Status}}' \
						redis.pool-1.1.1
				)"

				assert __shpec_matcher_egrep \
					"${health_status}" \
					"\"(starting|healthy|unhealthy)\""
			end

			sleep $(
				awk \
					-v interval_seconds="${interval_seconds}" \
					-v startup_time="${STARTUP_TIME}" \
					'BEGIN { print 1 + interval_seconds + startup_time; }'
			)

			it "Returns healthy after startup."
				health_status="$(
					docker inspect \
						--format='{{json .State.Health.Status}}' \
						redis.pool-1.1.1
				)"

				assert equal \
					"${health_status}" \
					"\"healthy\""
			end

			it "Returns unhealthy on failure."
				# wrapper failure
				docker exec -t \
					redis.pool-1.1.1 \
					bash -c "mv \
						/usr/bin/redis-server \
						/usr/bin/redis-server2" \
				&& docker exec -t \
					redis.pool-1.1.1 \
					bash -c "if [[ -n \$(pgrep -f '^/usr/bin/redis-server ') ]]; then \
						kill -9 \$(pgrep -f '^/usr/bin/redis-server ')
					fi"

				sleep $(
					awk \
						-v interval_seconds="${interval_seconds}" \
						-v retries="${retries}" \
						'BEGIN { print 1 + interval_seconds * retries; }'
				)

				health_status="$(
					docker inspect \
						--format='{{json .State.Health.Status}}' \
						redis.pool-1.1.1
				)"

				assert equal \
					"${health_status}" \
					"\"unhealthy\""
			end

			__terminate_container \
				redis.pool-1.1.1 \
			&> /dev/null
		end
	end

	trap - \
		INT TERM EXIT
}

if [[ ! -d ${TEST_DIRECTORY} ]]
then
	printf -- \
		"ERROR: Please run from the project root.\n" \
		>&2
	exit 1
fi

describe "jdeathe/centos-ssh-redis:latest"
	__destroy
	__setup
	test_basic_operations
	test_custom_configuration
	test_healthcheck
	__destroy
end
