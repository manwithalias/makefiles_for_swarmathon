MYIP = 

all: description

description:
	echo "This is the Makefile that got copied to the swarmie. \n\nEnter ('make runRover' or 'make runAndCompileRover').  You should run and compile every time you make changes to your code, or when you run new code on your laptop from github. A calibration window will come up in arduino.  Upload the code using the right arrow button, then click the serial monitor button on the far right.  Move the rover around and upside down till the numbers normalize.  Copy the max and min values to a document, then close the calibration window.  The swarmie_arduino window will now open.  Copy your max and min values into the right place, then upload the code. Close the swarmie_arduino winodw, and your swarmie will now connect to gazebo.  \n\nYou can also install the arduino code on a new rover by typing 'make download_IMU_code', 'make disable_modem_manager', then 'make update_rules', but only do this if the arduino code is not on the swarmie yet."

runRover: calibrate activate_node

runAndCompileRover: calibrate compile_code activate_node

compile_code: compile_code_notice.o
	cd rover_workspace && catkin build ; cd ~

compile_code_notice.o:
	echo "We are now recompiling the matching code on the rover"

activate_node: activate_node_description.o #makes the rover connect to gazebo on your computer, which is the master
	cd rover_workspace/misc/ && ./rover_onboard_node_launch.sh $(MYIP)

activate_node_description.o:
	echo "with rover_onboard_node_launch.sh activated, the rover now connects to gazebo on your computer, which is the master"

############################################
#IMU calibration
#from Swarmathon IMU Calibration video on youtube
#aruduino code to read min and max values as we rotate rover in space
#modify arduino code to help robot account for gps magnet that is on rover
#every rover has different magnetic properties, so this has to be done for each rover
#rovers have to be recalibrated every time they are moved to a new location so that they localize

download_IMU_code: download_arduino_ide untar_ide clone_original_logic_aruduino clone_pololu

#next make disable_modem_manager, then make update_rules with sudo password
 
#######################

#download latest aruduino ide:
download_arduino_ide:
	wget http://blog.spitzenpfeil.org/arduino/mirror_released/arduino-1.6.8-linux64.tar.xz disable_modem_manager

untar_ide:
	tar xf arduino-1.6.8-linux64.tar.xz

#clone original logic code that runs on the aruduino
clone_original_logic_aruduino:
	git clone https://github.com/BCLab-UNM/Swarmathon-Arduino.git

#clone calibration code from pololu, which specifies values we will plug into the swarmathon arduino code
clone_pololu:
	git clone https://github.com/pololu/lsm303-arduino.git

#disable ubuntu's built in modem manager that tries to controle the arduino. Add a rule to udev set that tells modem manager to ignore the board with the id for the Leonardo board.
disable_modem_manager:
	echo 'ATTRS{idVendor}=="1ffb", ENV{ID_MM_DEVICE_IGNORE}="1"' | sudo tee /etc/udev/rules.d/77-arduino.rules

#update the rules for ubuntu dev admin
update_rules:
	sudo udevadm trigger

##############

install_arduino:
	cd arduino-1.6.8/ && ./install.sh ; cd ~

install_arduino_alt:
	sudo apt-get install arduino



calibrate: run_Calibrate_ino run_Swarmathon_Arduino_ino

##############

#run the arduino software
run_Arduino:  #you may have to run this as sudo
	./arduino-1.6.8/arduino

##########
#set path to library
#from Swarmathon IMU Calibration Turorial Patch 1 video

#1open swarmie /lsm303-arduino/examples/Calibrate/Calibrate.ino, using arduino
#2upload Calibrate.imu using button

#3open sketch_mar28a
#4set tools->board->Arduino Leonardo
#5set tools->port->/dev/ttyACM1 (Arduino Leonardo)
#6set files->preferences ->browse-> /home/swarmie/Swarmaton-Arduino/

#7open swarmie/lsm303-arduino/lsm303/examples/Calibrate/Calibrate.imo
#8upload Calibrate.imo using button
###########

#open swarmie/lsm303-arduino/lsm303/examples/Calibrate/Calibrate.imo
run_Calibrate_ino:
	sudo ./arduino-1.6.8/arduino lsm303-arduino/examples/Calibrate/Calibrate.ino

#4set tools->board->Arduino Leonardo
#5set tools->port->/dev/ttyACM1 (Arduino Leonardo)
#upload code using right arrow button

#you might need to purge modemmanager if the calibration cannot see a .h file
purge_modemmanager_fix:
	sudo apt-get purge modemmanager

#click serial monitor icon button on far right to see output.  These values indicate the minimum and maximum magnitomitor readings from the IMU.  We will use these to calibrate the rover.  Pick up the rover and rotate it along every axis possible to explore its whole range of motion to find magnetic interferance.  Min and max values change, till they stablize.  We will use the last line of values to parameterize the arduino code on the rover, so that when it is moving through space, it will normalize these values to the min and maxes.
#turn off autoscroll, then copy the min and max values temporarily to a text editor.
#open arduino swarmathon code, to edit it and put in these values: open swarmie/ SwarmathonArduino/SwarmathonArduino/Swarmathon_Arduino.imo

#alter values on these 2 lines:  
#magnetometer_accelerometer.m_min = (LSM303::vector<int16_t>){  REPLACE MIN VALUES   };
#magnetometer_accelerometer.m_max = (LSM303::vector<int16_t>){  REPLACE MAX VALUES   };


#upload Swarmathon_Arduino.imo code to Leonardo using right arrow button
run_Swarmathon_Arduino_ino:  
	sudo ./arduino-1.6.8/arduino Swarmathon-Arduino/Swarmathon_Arduino/Swarmathon_Arduino.ino


