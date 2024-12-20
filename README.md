# av_gps

This repository hosts the required environment for running the ROS 2 Novatel GPS driver, specifically configured for running with a Novatel PwrPak7D GNSS receiver with dual antennas.


## Docker container
- **Operating System**: Ubuntu 22.04
- **ROS Distribution**: Humble Hawksbill
- **Novatel Drivers**:
    - `ros-humble-novatel-gps-driver `: Manages communication with the Novatel GPS receiver, from [novatel_gps_driver](https://github.com/swri-robotics/novatel_gps_driver)
    - `ros-humble-novatel-gps-msgs`: Custom Novatel ROS msgs [Included in apt as dependency of `ros-humble-novatel-gps-driver`]

    Note: Although the driver versions are not pinned in the Dockerfile, version `4.1.2-1` is the latest release available (via `apt` ) that has been tested on the vehicle sensor.

For more details please see [Dockerfile](./Dockerfile)


### ROS 2 launcher

The `av_gps_launch` ROS package contains the required launch files and configuration parameters for launching the driver for a Novatel PwrPak7D GNSS.


## Usage

 Quickly build and run the Docker container using `runtime.sh` for runtime or debugging, and `dev.sh` for a convenient development setup.

### Runtime or Debugging

Execute the ROS 2 nodes in runtime mode or start an interactive bash session for detailed debugging:

```bash
./runtime.sh [bash]
```

- **Without arguments**: Activates the container in runtime mode.
- **With `bash`**: Opens an interactive bash session for debugging.

### Development

Prepare a development setting that reflects local code modifications and simplifies the build process:

```bash
./dev.sh
```

- **Live Code Synchronization**: Mounts local `av_gps_launch` directory with the container.
- **Convenience Alias**: The development container features a `colcon_build` alias, which simplifies the ROS2 build process. Executing `colcon_build` runs `colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release` and then sources the `setup.bash` to ensure the environment is updated with the latest build artifacts. This alias enhances productivity by combining build commands and environment setup into a single, easy command.
