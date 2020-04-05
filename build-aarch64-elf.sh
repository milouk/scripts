#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

echo -e "${GREEN}Updating Packages${NOCOLOR}"

sh update-script.sh

echo -e "${GREEN}Fetching dependencies${NOCOLOR}"

sudo apt-get install --yes git gcc g++ gperf bison flex texinfo help2man make libncurses5-dev autoconf automake libtool libtool-bin gawk wget bzip2 xz-utils unzip patch python3 libstdc++6 subversion

echo -e "${GREEN}Cloning crosstool-ng${NOCOLOR}"

git clone https://github.com/crosstool-ng/crosstool-ng

echo -e "${GREEN}Entering crosstool-ng${NOCOLOR}"

cd crosstool-ng

echo -e "${GREEN}Bootstrap and Configure${NOCOLOR}"

./bootstrap && ./configure

echo -e "${GREEN}Compiling${NOCOLOR}"

make -j$(nproc --all)

echo -e "${GREEN}Installing${NOCOLOR}"

sudo make install

echo -e "${GREEN}Creating build${NOCOLOR}"

cd ..
mkdir build

echo -e "${GREEN}Copying defconfig to build${NOCOLOR}"

cp gcc-prebuilt-elf-toolchains/defconfig build/

echo -e "${GREEN}Entering build${NOCOLOR}"

cd build

echo -e "${GREEN}Crosstool defconfig${NOCOLOR}"

ct-ng defconfig

echo -e "${GREEN}Crosstool Build${NOCOLOR}"

ct-ng build

echo -e "${GREEN}Cleaning Repo${NOCOLOR}"

cd ..
cd gcc-prebuilt-elf-toolchains/
git fetch
git pull -r
rm -rf aarch64-linux-elf/
cd ..

echo -e "${GREEN}Copy toolchain to Repo${NOCOLOR}"

cd x-tools
cp -r aarch64-linux-elf/ ../gcc-prebuilt-elf-toolchains/

echo -e "${GREEN}Uploading to GitHub${NOCOLOR}"

cd ..
cd gcc-prebuilt-elf-toolchains/
commit_message="Upload $(date +'%d/%m/%Y') Build"
git add -A
git commit -m "$commit_message"
git push origin master -f

echo -e "${GREEN}Cleaning Up${NOCOLOR}"

cd ..
rm -rf build/
rm -rf crosstool-ng/
rm -rf x-tools/

echo -e "${GREEN}Done!${NOCOLOR}"
