#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

echo

echo -e "step 1: ${GREEN}pre-configuring packages${NOCOLOR}"
sudo dpkg --configure -a

echo

echo -e "step 2: ${GREEN}fix and attempt to correct a system with broken dependencies${NOCOLOR}"
sudo  apt install -f --yes

echo

echo -e "step 3: ${GREEN}update apt cache${NOCOLOR}"
sudo apt update --yes

echo

echo -e "step 4: ${GREEN}upgrade packages${NOCOLOR}"
sudo apt upgrade --yes

echo

echo -e "step 5: ${GREEN}distribution upgrade${NOCOLOR}"
sudo apt dist-upgrade --yes

echo

echo -e "step 6: ${GREEN}remove unused packages${NOCOLOR}"
sudo apt --purge autoremove --yes

echo

echo -e "step 7: ${GREEN}clean up${NOCOLOR}"
sudo apt autoclean --yes
sudo apt autoremove --yes
sudo apt clean --yes

echo
