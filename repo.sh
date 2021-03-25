#!/bin/bash

function error {
  echo -e "\e[91m$1\e[39m"
  exit 1
}

function ctrl_c() {
  break &>/dev/null
  rm repo.sh &>/dev/null
  exit 1
}
#make the ctr_c function run if ctrl+c is pressed
trap "ctrl_c" 2

function addrepo() {
  echo "You chose to add the repository. To cancel click ctrl+c in the next 5 seconds."
  sleep 5
  echo "Downloading package list..."
  sudo wget https://chunky-milk.github.io/raspbian-addons/rpirepo.list -O /etc/apt/sources.list.d/rpirepo.list || error "Failed to download rpirepo.list!"
  echo "Adding GPG key..."
  wget -qO- https://chunky-milk.github.io/raspbian-addons/KEY.gpg | sudo apt-key add - || error "Failed to add GPG key!"
  echo "Updating APT lists..."
  sudo apt update || error "Failed to update APT lists!"
}

function removerepo() {
  echo "You chose to remove the repository. To cancel click ctrl+c in the next 5 seconds."
  sleep 5
  echo "Removing rpirepo.list..."
  sudo rm /etc/apt/sources.list.d/rpirepo.list || error "Failed to remove rpirepo.list!"
  echo "Removing GPG key..."
  sudo apt-key remove "232E 6F29 77AB D48E 5A9F  AD03 9ACB 4E70 D84B FD24" || error "Failed to remove GPG key!"
  echo "Updating APT lists..."
  sudo apt update || error "Failed to update APT lists!"
}

printf "(i)nstall or (r)emove raspbian-addons repository "
while true; do
  read -p "(i/r)?" choice
  case "$choice" in 
    i|I ) addrepo && break ;;
    r|R ) removerepo && break ;;
    * ) echo "Invalid input!";;
  esac
done
echo "Bye!"
