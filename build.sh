#!/bin/bash

docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag amattera89/dockuwiki:1.0 .