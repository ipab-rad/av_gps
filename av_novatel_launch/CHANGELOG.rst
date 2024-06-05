^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package av_novatel_launch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
