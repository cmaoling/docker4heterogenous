#bin/bash
if [ "$( { docker container prune --help | grep "is not a docker command" > outfile; } 2>&1 )" == "" ];
then
	echo "docker container prune (NEW)"
	docker container prune -f
	echo "docker images prune (NEW)"
	#docker image prune -f
else
	echo "docker container prune (OLD)"
	#docker ps --filter "status=exited" | grep -e '[yh]s ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm
	echo "docker images prune (OLD>"
	#docker rmi -f $(docker images | grep "<none>" | grep -e "[yh]s ago"  | awk "{print \$3}")
fi

