#!/bin/bash
RED='\e[1;31m'
GREEN='\e[1;32m'
CYAN='\e[1;96m'
YELLOW='\e[1;33m'
COLOR_END='\e[0m'

function run_params() {
	echo "For running node:"
	echo -e $GREEN"-h|--help"$COLOR_END " - list of options"
    echo -e $GREEN"-w|--network"$CYAN"(NETWORK_NAME)"$COLOR_END " - name of Sovrin network"
    echo -e $GREEN"-n|--name"$CYAN"(NODE_NAME)"$COLOR_END " - name of Node"
    echo -e $GREEN"-p|--port"$CYAN"(NODE_PORT)"$COLOR_END " - network port for nodes comunication"
    echo -e $GREEN"-c|--client"$CYAN"(CLIENT_PORT)"$COLOR_END " - network port for clients connection"
    echo -e $GREEN"-s|--seed"$CYAN"(NODE_SEED)"$COLOR_END " - seed of node"
    echo -e $GREEN"-f|--file"$COLOR_END " - path to env file"
}

function manage_params() {
	echo "For managing node:"
	echo -e $GREEN"-h|--help"$COLOR_END "- list of options"
    echo -e $GREEN"-w|--network"$CYAN"(NETWORK_NAME)"$COLOR_END "- name of Sovrin network (required)"
    echo -e $GREEN"-n|--name"$CYAN"(NODE_NAME)"$COLOR_END "- name of Node (required)"
    echo -e $GREEN"-p|--port"$CYAN"(NODE_PORT)"$COLOR_END "- network port for nodes comunication (required for adding node)"
    echo -e $GREEN"-c|--client"$CYAN"(CLIENT_PORT)"$COLOR_END "- network port for clients connection (required for adding node)"
    echo -e $GREEN"-s|--seed"$CYAN"(NODE_SEED)"$COLOR_END "- seed of node (required)"
    echo -e $GREEN"-t|--steward"$CYAN"(STEWARD_SEED)"$COLOR_END "- seed of steward NYM (required)"
    echo -e $GREEN"-i|--ip"$CYAN"(IP)"$COLOR_END "- static external IP of node (required for adding node)"
    echo -e $GREEN"-r|--service"$CYAN"(SERVICE)"$COLOR_END "- VALIDATOR for (re-)adding, empty for removing node"
    echo -e $GREEN"-f|--file"$COLOR_END "- path to file with parameters"
    echo ''
    echo -e $RED"!!! For adding NYM should be created first at admin dashboard !!!"$COLOR_END
}

function genesises() {
	echo -e $RED"!!! Genesises files should be added to the /var/lib/indy/<NETWORK_NAME> folder !!!"$COLOR_END
}

function notify() {
	echo -e "There are "$CYAN"ENV variables"$COLOR_END" analog to "$GREEN"options"$COLOR_END" in brackets"
}

function help() {
	echo ""
	echo -e "Usage: "$GREEN"entrypoint.sh [COMMAND] [OPTIONS]"$COLOR_END
	echo ''
	echo "Utility for managing indy nodes"
	echo ''
	echo "Commands:"
	echo -e $GREEN"run"$COLOR_END " - run the node"
	echo -e $GREEN"manage"$COLOR_END " - adding and removing node"
	echo -e $GREEN"usage"$COLOR_END " - show this message"
	echo ''
	echo "Options:"
	run_params
	echo ''
	genesises
    echo ''
    manage_params
    echo ''
    genesises
    echo ''
    notify
}