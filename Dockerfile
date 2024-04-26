FROM ros:humble-ros-base-jammy AS base

# Switch to much faster mirror for apt processes
ENV OLD_MIRROR archive.ubuntu.com
ENV SEC_MIRROR security.ubuntu.com
ENV NEW_MIRROR mirror.bytemark.co.uk

RUN sed -i "s/$OLD_MIRROR\|$SEC_MIRROR/$NEW_MIRROR/g" /etc/apt/sources.list

# Install key dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get -y --quiet --no-install-recommends install \
        libpcap0.8-dev \
        ros-"$ROS_DISTRO"-gps-msgs \
        ros-"$ROS_DISTRO"-swri-math-util \
        ros-"$ROS_DISTRO"-swri-roscpp \
        ros-"$ROS_DISTRO"-swri-serial-util \
        # Novatel GPS
        ros-"$ROS_DISTRO"-novatel-gps-driver \
        ros-"$ROS_DISTRO"-novatel-gps-msgs \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS workspace folder
ENV ROS_WS /opt/ros_ws
WORKDIR $ROS_WS

# -----------------------------------------------------------------------

FROM base as prebuilt

# Import novatel launch
COPY av_novatel_launch $ROS_WS/src/av_novatel_launch

# Build code from launch pkg
RUN . /opt/ros/"$ROS_DISTRO"/setup.sh \
    && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release

# -----------------------------------------------------------------------

FROM base as dev

# Install basic dev tools (And clean apt cache afterwards)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get -y --quiet --no-install-recommends install \
        # Command-line editor
        nano \
        # Ping network tools
        inetutils-ping \
        # Bash auto-completion for convenience
        bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Add sourcing local workspace command to bashrc for convenience when
#   running interactively
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc && \
    # Add colcon build alias for convenience
    echo 'alias colcon_build="colcon build --symlink-install --cmake-args \
    -DCMAKE_BUILD_TYPE=Release && source install/setup.bash"' >> /root/.bashrc

# Enter bash for development
CMD ["bash"]

# -----------------------------------------------------------------------

FROM base as runtime

# Copy artifacts/binaries from prebuilt
COPY --from=prebuilt $ROS_WS/install $ROS_WS/install

# Add command to docker entrypoint to source newly compiled
#   code when running docker container
RUN sed --in-place --expression \
      "\$isource \"$ROS_WS/install/setup.bash\" " \
      /ros_entrypoint.sh

# launch ros package
CMD ["ros2", "launch", "av_novatel_launch", "av_novatel.launch.xml"]
