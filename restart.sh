docker-compose stop
docker-compose start
NAME=$(docker-compose ps | sed -n 3p | awk '{print $1}')
#docker cp /J2/resolv.conf $NAME:/etc/resolv.conf
#docker exec $NAME sh /etc/rc.local
docker exec $NAME cp /resolv.conf /etc/resolv.conf
docker-compose logs -f --tail="10"
