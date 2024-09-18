cmake_minimum_required(VERSION 3.5)
project(av_gps_launch)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release)
endif()

find_package(ament_cmake_ros REQUIRED)
find_package(novatel_gps_driver REQUIRED)

# Installation...

install(DIRECTORY launch DESTINATION share/${PROJECT_NAME})

install(DIRECTORY config DESTINATION share/${PROJECT_NAME})

ament_package()
