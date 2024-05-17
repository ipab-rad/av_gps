^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package av_novatel_launch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Forthcoming
-----------
* Add Cyclone DDS as ROS RMW + high msg throughput configuration
* Modify `dev.sh` to avoid overriding `latest` docker tag for convenience
* Enable colorised ROS log
* Contributors: Hector Cruz (hect95)

1.0.0 (2024-04-30)
------------------
* Porting code from ipab-rad/novategl_gps_driver
  - The novatel ROS 2 driver is now installed from
  the apt repository rather than from source
  - Preserving same the run.sh and dev.sh functionality
* Contributors: Hector Cruz
