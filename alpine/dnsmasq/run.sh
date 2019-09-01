IP=192.168.5.200
docker run --restart always --name dnsmasq --net bridge1 -p $IP:53:53/udp  -p $IP:53:53/tcp -d colinas/dnsmasq:latest
