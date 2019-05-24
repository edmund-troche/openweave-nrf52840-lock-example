#!/bin/sh

#
#    Copyright 2019 Google LLC All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

#
#    Description:
#      Travis CI build preparation script for the nRF52840 target on Linux.
#

# Set tools download links
#

NORDIC_SDK_FOR_THREAD_URL=https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5-SDK-for-Thread/nRF5-SDK-for-Thread-and-Zigbee/nRF5SDKforThreadandZigbeev300d310e71.zip

NORDIC_COMMAND_LINE_TOOLS_URL=https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF5-command-line-tools/sw/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar

ARM_GCC_TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2

TMPDIR=${TMPDIR-/tmp}

# --------------------------------------------------------------------------------

set -x

# Install Nordic nRF52840 SDK for Thread and Zigbee
#

wget -O ${TMPDIR}/nordic_sdk_for_thread.zip -nv ${NORDIC_SDK_FOR_THREAD_URL} || exit 1
unzip -d ${TRAVIS_BUILD_DIR}/nRF5x-SDK-for-Thread-and-Zigbee -q ${TMPDIR}/nordic_sdk_for_thread.zip || exit 1
rm ${TMPDIR}/nordic_sdk_for_thread.zip

# Install Nordic nRF5x Command Line Tools
#

wget -O ${TMPDIR}/nordic_command_line_tools.tar -nv ${NORDIC_COMMAND_LINE_TOOLS_URL} || exit 1
mkdir ${TRAVIS_BUILD_DIR}/nRF5x-Command-Line-Tools
tar -C ${TRAVIS_BUILD_DIR}/nRF5x-Command-Line-Tools -xf ${TMPDIR}/nordic_command_line_tools.tar || exit 1
rm ${TMPDIR}/nordic_command_line_tools.tar

# Install ARM GCC Toolchain
#

wget -O ${TMPDIR}/arm_gcc_toolchain.tar.bz2 -nv ${ARM_GCC_TOOLCHAIN_URL} || exit 1
mkdir ${TRAVIS_BUILD_DIR}/arm
tar -jxf ${TMPDIR}/arm_gcc_toolchain.tar.bz2 --directory ${TRAVIS_BUILD_DIR}/arm || exit 1
rm ${TMPDIR}/arm_gcc_toolchain.tar.bz2

# Initialize and update all submodules within the example app.
#
git -C ${TRAVIS_BUILD_DIR} submodule init || exit 1
git -C ${TRAVIS_BUILD_DIR} submodule update || exit 1

set +x

# Log relevant build information.
#
echo '---------------------------------------------------------------------------'
echo 'nRF52840 Build Preparation Complete'
echo ''
echo "openweave-core branch: ${TRAVIS_BRANCH}"
echo "Nordic SDK for Thread and Zigbee: ${NORDIC_SDK_FOR_THREAD_URL}"
echo "Nordic nRF5x Command Line Tools: ${NORDIC_COMMAND_LINE_TOOLS_URL}"
echo "ARM GCC Toolchain: ${ARM_GCC_TOOLCHAIN_URL}"
echo 'Commit Hashes'
echo '  openweave-nrf52840-lock-example: '`git -C ${TRAVIS_BUILD_DIR} rev-parse --short HEAD`
echo '---------------------------------------------------------------------------'
