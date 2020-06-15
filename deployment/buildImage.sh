#!/bin/sh
DOCKERHUB_NAME="mwangxx"
echo $DOCKERHUB_NAME

if [ "$#" -ne 1 ]; then
    echo "Miss image version"
    exit 1
fi

# generate docker-compose.yml

git pull

echo "\n\n#Api version\napi.version=$1" >> ../backend/src/main/resources/application-prod.properties

sed "s/BULLETJOURNAL_VERSION/$1/g" docker-compose-TEMPLATE.yml > docker-compose.yml

git add docker-compose.yml

git commit -m "release $1"

git push

# build images

# cd ../discourse-auth-proxy
# docker build -t xcode1024/auth-proxy .

cd ..

cd ./frontend
docker build -t $DOCKERHUB_NAME/bulletjournal-frontend:$1 .
cd ..

cd ./backend
DOCKER_BUILDKIT=1 docker build -t $DOCKERHUB_NAME/bulletjournal-backend:$1 .
cd ../deployment

# docker push xcode1024/auth-proxy:latest
docker push $DOCKERHUB_NAME/bulletjournal-frontend:$1
docker push $DOCKERHUB_NAME/bulletjournal-backend:$1
