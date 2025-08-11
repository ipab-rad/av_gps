FROM ros:humble-ros-base-jammy AS base

# Switch to much faster mirror for apt processes
ENV OLD_MIRROR=archive.ubuntu.com
ENV SEC_MIRROR=security.ubuntu.com
ENV NEW_MIRROR=mirror.bytemark.co.uk

RUN sed -i "s/$OLD_MIRROR\|$SEC_MIRROR/$NEW_MIRROR/g" /etc/apt/sources.list

# Install key dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get -y --quiet --no-install-recommends install \
        # Install Cyclone DDS ROS RMW
        ros-"$ROS_DISTRO"-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

# Setup ROS workspace folder
ENV ROS_WS=/opt/ros_ws
WORKDIR $ROS_WS

# Set cyclone DDS ROS RMW
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

COPY ./cyclone_dds.xml $ROS_WS/

# Configure Cyclone cfg file
ENV CYCLONEDDS_URI=file://${ROS_WS}/cyclone_dds.xml

# Enable ROS log colorised output
ENV RCUTILS_COLORIZED_OUTPUT=1

# -----------------------------------------------------------------------

FROM base AS prebuilt

# Clone fork of novatel driver
RUN mkdir -p /opt/ros_ws/src \
    && git clone -b add_logging_throttle https://github.com/ipab-rad/novatel_gps_driver.git src \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        rosdep install --from-paths . --ignore-src -y -r \
    && . /opt/ros/"$ROS_DISTRO"/setup.sh \
    && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release \
    && rm -rf /var/lib/apt/lists/*

# Import gps launch
COPY av_gps_launch $ROS_WS/src/av_gps_launch

# Build code from launch pkg
RUN . /opt/ros/"$ROS_DISTRO"/setup.sh \
    && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# -----------------------------------------------------------------------

FROM prebuilt AS dev

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

FROM prebuilt AS runtime

# Add command to docker entrypoint to source newly compiled
#   code when running docker container
RUN sed --in-place --expression \
      "\$isource \"$ROS_WS/install/setup.bash\" " \
      /ros_entrypoint.sh

# launch ros package
CMD ["ros2", "launch", "av_gps_launch", "av_gps.launch.xml"]
