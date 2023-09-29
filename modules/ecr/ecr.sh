#!/bin/bash

repository_url=$1

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin "$repository_url"

docker pull containous/whoami
docker tag containous/whoami:latest $repository_url:latest
docker push $repository_url:latest