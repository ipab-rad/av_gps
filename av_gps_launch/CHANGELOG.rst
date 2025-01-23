^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package av_gps_launch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Forthcoming
-----------
* Update parameters
  - Set use_binary_message to false to avoid ASCII parsing warnings
  - Set publish_imu_messages to false as IMU is not integrated on
  current GNSS
  - Define wait_for_sync to wait for both BESTPOS and BESTVEL messages
  to arrive before publishing gps_msgs/GPSFix
* Contributors: Hector Cruz

1.3.0 (2024-12-03)
------------------
* Enable publishing of GPS heading and meta
  information

* Contributors: Hector Cruz

1.2.1 (2024-09-18)
------------------
* Rename all av_novatel references to av_gps (`#10 <https://github.com/ipab-rad/av_gps/issues/10>`_)
  - To keep convention, we should abstract and avoid referring to
  specific brands/products when naming software components. Some
  exceptions are allowed such as velodyne/ouster to help differentiate.
  - Minor fixes to README
* Contributors: Alejandro Bordallo

1.2.0 (2024-06-05)
------------------
* Add bash args to optionally load local cyclone_dds
* Contributors: Alejandro Bordallo, hect95

1.1.0 (2024-05-21)
------------------
* Add Cyclone DDS as ROS RMW + high msg throughput configuration
* Modify `dev.sh` to avoid overriding `latest` docker tag for convenience
* Enable colorised ROS log
* Changing driver namespace from `/sensor/gps/rear` to `/sensor/gps` 
* Synchronise host time with docker container
* Contributors: Hector Cruz (hect95)

1.0.0 (2024-04-30)
------------------
* Porting code from ipab-rad/novategl_gps_driver
  - The novatel ROS 2 driver is now installed from
  the apt repository rather than from source
  - Preserving same the run.sh and dev.sh functionality
* Contributors: Hector Cruz
