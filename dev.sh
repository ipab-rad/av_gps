#!/bin/bash
# ----------------------------------------------------------------
# Build docker dev stage and add local code for live development
# ----------------------------------------------------------------

# Build docker image up to dev stage
DOCKER_BUILDKIT=1 docker build \
    -t av_gps:latest-dev \
    -f Dockerfile --target dev .

# Run docker image with local code volumes for development
docker run -it --rm --net host --privileged \
    -v /dev/shm:/dev/shm \
    -v /etc/localtime:/etc/localtime:ro \
    -v ./av_novatel_launch:/opt/ros_ws/src/av_novatel_launch \
    av_gps:latest-dev
