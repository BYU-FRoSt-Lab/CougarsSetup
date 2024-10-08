#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Sets up CoUGARs requirements on a new RPi 5
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run 'compose.sh' to load in and run
#   the most current image
# - This script can also be used to set up a new development
#   environment on a personal machine

function printInfo {
  echo -e "\033[0m\033[36m[INFO] $1\033[0m"
}

function printWarning {
  echo -e "\033[0m\033[33m[WARNING] $1\033[0m"
}

function printError {
  echo -e "\033[0m\033[31m[ERROR] $1\033[0m"
}

if [ "$(uname -m)" == "aarch64" ]; then

  echo ""
  printInfo "Setting up CoUGARs on a Raspberry Pi 5"
  echo ""
            
  # Install Docker if not already installed
  if ! [ -x "$(command -v docker)" ]; then
      
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      rm get-docker.sh

      sudo usermod -aG docker $USERNAME
  else

      echo ""
      printWarning "Docker is already installed"
      echo ""
  fi

  # Install dependencies
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y vim tmux chrony git mosh

  # Set up volumes
  mkdir ~/bag
  cp -r ~/CoUGARs/config ~

  # Set up udev rules
  sudo ln -s ~/config/local/00-teensy.rules /etc/udev/rules.d/00-teensy.rules
  sudo udevadm control --reload-rules
  sudo udevadm trigger

  # Set up config files
  sudo ln -s ~/config/local/chrony.conf /etc/chrony/chrony.conf
  sudo ln -s ~/config/local/.tmux.conf ~/.tmux.conf

  # Copy repos from GitHub
  git clone https://github.com/BYU-FRoSt-Lab/cougars-ros2.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-teensy.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-gpio.git

  echo ""
  printInfo "Make sure to set the vehicle-specific params in "network_id.sh" and "vehicle_config.yaml" in "~/config" now"
  echo ""

else

  echo ""
  printInfo "Setting up CoUGARs on a development machine"
  echo ""

  # Set up volumes
  mkdir ~/bag
  cp -r ~/CoUGARs/config ~

  # Copy repos from GitHub
  git clone https://github.com/BYU-FRoSt-Lab/cougars-ros2.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-teensy.git
  git clone https://github.com/BYU-FRoSt-Lab/cougars-gpio.git

fi
