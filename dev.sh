#!/bin/bash
# ----------------------------------------------------------------
# Build docker dev stage and add local code for live development
# ----------------------------------------------------------------

# Build docker image up to dev stage
DOCKER_BUILDKIT=1 docker build \
    -t av_gps:latest \
    -f Dockerfile --target dev .

# Run docker image with local code volumes for development
docker run -it --rm --net host --privileged \
    -v /dev/shm:/dev/shm \
    -v ./av_novatel_launch:/opt/ros_ws/src/av_novatel_launch \
    -v ./novatel_gps_driver:/opt/ros_ws/src/novatel_gps_driver \
    -v ./novatel_gps_msgs:/opt/ros_ws/src/novatel_gps_msgs \
    av_gps:latest
