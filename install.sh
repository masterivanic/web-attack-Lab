#!/bin/bash

## All attack and utils command here
source .env

architecture=""
mysqlImage=""

#docker buildx build -t local/kali-machine -f Dockerfile.machine .
#docker run --rm -it -p 80:80 vulnerables/web-dvwa --name vulnerable-container

function getArchitecture(){
    case $(uname -m) in
        i386)   architecture="386" ;;
        i686)   architecture="386" ;;
        x86_64) architecture="amd64" ;;
        arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
    esac
}

function startMysqlDb() {
    echo "starting mysql container...."
    docker run --name db-container \
      -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
      -e MYSQL_USER=${MYSQL_USER} \
      -e MYSQL_PASSWORD=${MYSQL_USER} \
      -e MYSQL_DATABASE=${MYSQL_DATABASE} \
      -d ${mysqlImage}
}

getArchitecture

if [[ ${architecture} == "arm" ]]; then
    mysqlImage="mysql:8"
elif [[ ${architecture} == "x86_64" ]]; then
    mysqlImage="mysql:8.0.42-bookworm"
else
    echo "Unsupported platform"
fi

startMysqlDb