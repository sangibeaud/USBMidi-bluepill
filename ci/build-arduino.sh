#!/bin/bash
## Exit immediately if a command exits with a non-zero status.
set -e

# Enable the globstar shell option
shopt -s globstar

# Make sure we are inside the github workspace
cd $GITHUB_WORKSPACE

# Create directories
mkdir $HOME/Arduino
mkdir $HOME/Arduino/libraries

# Install Arduino IDE
export PATH=$PATH:$GITHUB_WORKSPACE/bin
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
arduino-cli config init
arduino-cli core update-index

# Install Arduino default core // --remove me
arduino-cli core install arduino:avr
# Install Arduino STM32 core
# arduino-cli core update-index --additional-urls https://github.com/stm32duino/BoardManagerFiles/raw/main/package_stmicroelectronics_index.json
arduino-cli core update-index --additional-urls http://dan.drown.org/stm32duino/package_STM32duino_index.json
#--additional-urls https://stm32duinoforum.com/forum/stm32duino/package_STM32duino_index.js
#arduino-cli core install --additional-urls https://github.com/stm32duino/BoardManagerFiles/raw/main/package_stmicroelectronics_index.json  STMicroelectronics:stm32
arduino-cli core install --additional-urls http://dan.drown.org/stm32duino/package_STM32duino_index.json stm32duino:STM32F1

# Link Arduino library
ln -s $GITHUB_WORKSPACE $HOME/Arduino/libraries/CI_Test_Library

# Compile all *.ino files for the Arduino Uno
for f in **/*.ino ; do
    arduino-cli compile -v -b stm32duino:STM32F1:genericSTM32F103C $f
    #arduino-cli compile -b stm32duino:STM32F1:bluepill $f
done
