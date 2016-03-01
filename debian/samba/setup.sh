#!/bin/bash
set -e

echo "RUNNING $@"
USER=${USER:-"root"}
PASSWORD=${PASSWORD:-"tcuser"}
USERID=${USERID:-1000}
GROUP=${GROUP:-"root"}
DOCKER_HOST=${DOCKER_HOST:-"unix:///docker.sock"}
READONLY=${READONLY:-"no"}

args=("$@")
# Running as an Entrypoint means the script is not arg0
container=${args[0]}
if [ "$container" = "--start" ]; then
	echo "Setting up samba cfg ${args[@]}"
	container=${args[1]}
	#TODO: can we detect the ownership / USERID setting in the destination container?
	CONTAINER=$container

	#for i in $(seq 2 ${#args[@]}); do
	LIMIT=${#args[@]}
	# last one is an empty string
	mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
	sed 's/\[global\]/\[global\]\n  log level = 0/' /etc/samba/smb.conf.bak > /etc/samba/smb.conf
	for ((i=2; i < LIMIT ; i++)); do
		vol="${args[i]}"
		echo "add $vol"
		export VOLUME=$vol

		export VOLUME_NAME=$(echo "$VOLUME" |sed "s/\///" |tr '[\/<>:"\\|?*+;,=]' '_')

		cat /share.tmpl | envsubst >> /etc/samba/smb.conf
	done

	cat /etc/samba/smb.conf

        if ! id -u $USER > /dev/null 2>&1; then
		useradd $USER --uid $USERID --user-group --password $PASSWORD --home-dir /
	fi
	/etc/init.d/samba start
	echo "watching /var/log/samba/*"
	tail -f /var/log/samba/*
	#this should allow the samba-server to be --rm'd
	exit 0
fi
if [ "${args[0]}" = "--start" ]; then
	echo "Error: something went very wrong"
	exit 1
fi

usage() {
	echo
	echo "please run with:"
	#TODO: what happens if 'docker' is an alias?
	#TODO: watch for the --privileged introspection PR merge
	echo "   docker run --rm -v \$(which docker):/docker -v /var/run/docker.sock:/docker.sock -e DOCKER_HOST svendowideit/samba ${args[0]}"
	echo ""
	echo " OR - depending on your Docker Host's socket connection and location of its docker binary"
	echo ""
	echo "   docker run --rm -v /usr/local/bin/docker:/docker -e DOCKER_HOST svendowideit/samba ${args[0]}"
	echo
	exit 1
}
