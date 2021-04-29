#!/bin/bash

set -e

source /scripts/common.sh

function error() {
	echo -e $RED"${1}"$COLOR_END
	echo ''
	run_params
	echo ''
	genesises
	exit 1
}

function read_cli_params() {
	while [[ $# -gt 0 ]]; do
		key="$1"
		case ${key} in
			-h|--help)
				run_params
				exit 0
				;;
			-n|--name)
				if [[ -z ${NODE_NAME} ]]; then
					NODE_NAME="${2}"
				fi
				shift
				;;
			-w|--network)
				if [[ -z ${NETWORK_NAME} ]]; then
					NETWORK_NAME="${2}"
				fi
				shift
				;;
			-p|--port)
				if [[ -z ${NODE_PORT} ]]; then
					NODE_PORT="${2}"
				fi
				shift
				;;
			-c|--client)
				if [[ -z ${CLIENT_PORT} ]]; then
					CLIENT_PORT="${2}"
				fi
				shift
				;;
			-s|--seed)
				if [[ -z ${NODE_SEED} ]]; then
					NODE_SEED="${2}"
				fi
				shift
				;;
			-f|--file)
                set -a
                [[ -f "${2}" ]] && source "${2}"
                set +a
				break
				;;
			*)
				shift
				;;
		esac
	done
}

function check_start_params() {
    echo -n "Check initial params: "
    [ -z "${NODE_NAME}" ] && error "Error - Node name is not provided"
    [ -z "${NETWORK_NAME}" ] && error "Error - Network name is not provided"
    [ -z "${NODE_SEED}" ] && error "Error - Node seed is not provided"
    echo -e $GREEN"OK"$COLOR_END
}

function base_configure() {
    echo -n "Apply base configuration: "
    sed -i "s/NETWORK_NAME.*/NETWORK_NAME = \"${NETWORK_NAME}\"/" /etc/indy/indy_config.py
    sed -i "s/enableStdOutLogging = False/enableStdOutLogging = True/" /etc/indy/indy_config.py
    echo -e $GREEN"OK"$COLOR_END
}

function prepare_env() {
    echo -n "Generate keys: "
    init_indy_keys --name "${NODE_NAME}" --seed "${NODE_SEED}" > /tmp/keys
    echo -e $GREEN"OK"$COLOR_END
    echo ""
    echo "Keys:"
    cat /tmp/keys
    rm -f /tmp/keys
    echo ""
}

function check_genesis_exist() {
    echo -n "Check genesis files exist: "
    [ ! -d "/var/lib/indy/${NETWORK_NAME}" ] && error "Error - Network folder does not exist"
    [ ! -f "/var/lib/indy/${NETWORK_NAME}/pool_transactions_genesis" ] && error "Error - Pool genesis file does not exist"
    [ ! -f "/var/lib/indy/${NETWORK_NAME}/domain_transactions_genesis" ] && error "Error - Domain genesis file does not exist"
	echo -e $GREEN"OK"$COLOR_END
}

function check_node_config_exist() {
    node_dirs='bls_keys private_keys public_keys sig_keys verif_keys'
    client_dirs='private_keys public_keys sig_keys verif_keys'

    result='true'

    if [ ! -d "/var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}" ]; then result='false'; fi
    if [ ! -d "/var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}C" ]; then result='false'; fi
    for dir in ${node_dirs}; do
        if [ ! -d "/var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}/${dir}" ]; then result='false'; fi
        [ "$(ls -A /var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}/${dir} 2> /dev/null)" ] || result='false'
    done
    for dir in ${client_dirs}; do
        if [ ! -d "/var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}/${dir}" ]; then result='false'; fi
        [ "$(ls -A /var/lib/indy/${NETWORK_NAME}/keys/${NODE_NAME}/${dir} 2> /dev/null )" ] || result='false'
    done

    echo "${result}"
}

function main() {
	read_cli_params "$@"
	check_start_params
	check_genesis_exist
	base_configure
	echo -n "Check node configuration: "
	if [ "$(check_node_config_exist)" = 'false' ]; then
		echo "FAIL"
    	prepare_env
	else
		echo -e $GREEN"OK"$COLOR_END
	fi
	echo -e $GREEN"Starting node!"$COLOR_END
    echo ""
	start_indy_node ${NODE_NAME} 0.0.0.0 ${NODE_PORT} 0.0.0.0 ${CLIENT_PORT}
}

main "$@"
