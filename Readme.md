## Apache Hadoop 2.7.7 Docker images

# The Docker Hadoop 2.7.7 Ecosystem Images:

01. [Namenode](https://hub.docker.com/r/brpedromaia/hadoop-namenode)
02. [Yarn](https://hub.docker.com/r/brpedromaia/hadoop-yarn)
03. [Datanode](https://hub.docker.com/r/brpedromaia/hadoop-datanode)
04. [Mysql](https://hub.docker.com/r/brpedromaia/mysql)
05. [Hive](https://hub.docker.com/r/brpedromaia/hadoop-hive)
06. [Oracle](https://hub.docker.com/r/brpedromaia/oracle)
07. [Sqoop](https://hub.docker.com/r/brpedromaia/hadoop-sqoop)

# To pull and start the he Docker Hadoop 2.7.7 Ecosystem:
***create docker-compose.yml file with: ***
Last update: 23/08/2018 - 16:58
```
version: '3'
networks: 
  dockerlan:
services:
# Start the namenode container
  namenode:
    container_name: namenode
    image: brpedromaia/hadoop-namenode
    networks:
     - dockerlan
    ports:
     - "50070:50070"
    hostname: "namenode"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the yarn container
  yarn:
    container_name: yarn
    image: brpedromaia/hadoop-yarn
    networks:
     - dockerlan
    ports:
     - "8088:8088"
     - "19888:19888"
    hostname: "yarn"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the datanode container
  datanode:
    container_name: datanode
    image: brpedromaia/hadoop-datanode
    networks:
     - dockerlan
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the mysql container
  mysql:
    container_name: mysql
    image: brpedromaia/mysql
    networks:
     - dockerlan
    ports:
     - "3306:3306"
    hostname: "mysql"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the hive container
  hive:
    container_name: hive
    image: brpedromaia/hadoop-hive
    networks:
     - dockerlan
    ports:
     - "21:22"
     - "10000:10000"
     - "10002:10002"
    hostname: "hive"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the oracle container
  oracle:
    container_name: oracle
    image: brpedromaia/oracle
    networks:
     - dockerlan
    ports:
     - "8080:8080"
     - "1521:1521"
    hostname: "oracle"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"
# Start the sqoop container
  sqoop:
    container_name: sqoop
    image: brpedromaia/hadoop-sqoop
    networks:
     - dockerlan
    ports:
     - "4422:22"
    hostname: "sqoop"
    volumes:
     - "$HOST_REPO:$DOCKER_REPO"

```

***create .env file with: (REQUIRED)***
Last update: 23/08/2018 - 16:58
```
HOST_REPO=~/Documents/packages
DOCKER_REPO=/var/lib/packages
```
***In docker-compose.yml folder execute:***
```
docker-compose up
```

# To remake the Docker Hadoop 2.7.7 Ecosystem:
***In docker-compose.yml folder execute:***
```
docker-compose rm -f&&docker-compose pull && docker-compose up
```
