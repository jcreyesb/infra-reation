#!/bin/bash

repository_url=$1

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$repository_url"

docker pull containous/whoami
docker tag containous/whoami:latest $repository_url:latest
docker push $repository_url:latest