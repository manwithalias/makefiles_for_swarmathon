MYUSERNAME = 

#SWARMIEIP = 
SWARMIEIP = 
SWARMIEUSERNAME = 
SWARMIEPASSWORD = 


all: echo_important_instructions

runGazebo: gazebo
runMyCode: compile_gazebo gazebo
runGitCode: echo_git_instructions openGit

runSwarmie: echo_swarmie_instrucitons openSwarmie

echo_important_instructions:
	echo "To run a rover, you must enter ('make runGitCode', 'make runMyCode', or 'make runGazebo' in one terminal, and then 'make runSwarmie' in another terminal. Run 'make' again when the virtual terminal connects for more instructions."

echo_git_instructions:
	echo "The function of this makefile is to speed up the process of starting a rover, and to help you match your code to the DEV branch of github. This makefile, along with Makefile, belong on your laptop in the rover_workspace folder.  You will need to install sshpass to make this work.  Fill in MYUSERNAME, SWARMIEIP, SWARMIEUSERNAME, SWARMIEPASSWORD inside makefile to make this operate.  Also, open Makefile, and fill in MYIP.  You can find your ip in the wifi icon on your latop by slecting 'Connection Information'.  You will have to connect your rover to a screen to find the rovers ip address, then also select 'Connection Information.'  The username is found in the terminal as username@whatever.  Run this file to copy and run github code by typing in rover_workspace of your terminal: make. You will have to enter a password to connect to the rover, then just type make again, and the rover will be connected. (A timestamped copy of the code that was on your computer will be put in the 'oldSwarmieCode' folder)  You can coose to run code from Github, or from your laptop by typing: 'make runMyCode' or 'make runGitCode'.  You can also ssh into your robot without a password using: make SSH_to_swarmie. Enjoy!"

echo_swarmie_instrucitons:
	echo "This program copies your rover_workspace src source files, and Makefile, from your computer to the swarmie to make sure they match, then it compiles them on the swarmie and runs the swarmie node. To run the swarmie, first make sure gazebo is running on your computer from another terminal.  Go to rover_workplace and type: 'make runSwarmie'.  Once you are logged into the rover, the terminal username will change to swarmie@(roversname). Type in 'make' again and press enter to initialize Makefile on the rover.  Now your rover is connected to gazebo, and you can select it on the screen. You can exit the rover terminal using 'exit'."

#########################################
install_sshpass.o: #install sshpass if it is not already installed
	sudo apt-get install sshpass


#########################################you will need to enter your password
###############once you ssh into the swarmie, then just type make again
openSwarmie: copy_files_to_swarmie copy_makefile_to_swarmie SSH_to_swarmie

copy_files_to_swarmie:
	sshpass -p "$(SWARMIEPASSWORD)" scp -r /home/$(MYUSERNAME)/rover_workspace/src/. $(SWARMIEUSERNAME)@$(SWARMIEIP):/home/$(SWARMIEUSERNAME)/rover_workspace/src

copy_makefile_to_swarmie:
	sshpass -p "$(SWARMIEPASSWORD)" scp -r /home/$(MYUSERNAME)/rover_workspace/Makefile $(SWARMIEUSERNAME)@$(SWARMIEIP):/home/$(SWARMIEUSERNAME)/

SSH_to_swarmie: #you need to install sshpass to make this work
	sshpass -p $(SWARMIEPASSWORD) ssh -X $(SWARMIEUSERNAME)@$(SWARMIEIP)

copy_files_to_swarmie_password_needed:
	scp -r /home/$(MYUSERNAME)/rover_workspace/src/. $(SWARMIEUSERNAME)@$(SWARMIEIP):/home/$(SWARMIEUSERNAME)/src

sleep10:
	@sleep 10

catkin_build_swarmie:
	sshpass -p'$(SWARMIEPASSWORD)' ssh -X $(SWARMIEUSERNAME)@$(SWARMIEIP) cd rover_workspace && catkin build

run_node_swarmie:

build: SSH_to_swarmie
	sshpass -p $(SWARMIEPASSWORD) ssh -C $(SWARMIEUSERNAME)@$(SWARMIEIP) cd rover_workspace && catkin build


#####################################333
########################################
#########################################
openGit: makefile_Description.o load_github_clone_files compile_gazebo gazebo

makefile_Description.o:
	echo -e "\n\n description \n We are now running our makefile to run the swarmie software\n"

###########################################################

load_github_clone_files: load_github_clone_files_Description.o remove_clone_junk_files.o copy_your_old_files_into_timestamp_backup.o git_clone.o copy_clone_files_into_right_palce.o remove_clone_junk_files.o


load_github_clone_files_Description.o:
	echo -e "\n\n description \n make backup of old code on your laptop into OldSwarmieCode with timestamp, then load code from github into right place\n"

install_git:
	sudo apt-get install git

git_clone.o: git_clone_descripiton.o
	git clone -b DEV https://github.com/CNMSwarmTeam/CNM-SRWG-2017.git

git_clone_descripiton.o:
	echo -e "\n\n description \n lets download the dev branch of our teams git repository\n"

make_backup_folder.o:  #mkdir OldSwarmieCode/Swarmie$(date +%Y%m%d_%H%M%S)
	@now=$$(date +%Y%m%d_%H%M%S); \
	mkdir -p OldSwarmieCode \
	mkdir -p OldSwarmieCode/swarmie$$now \ 

copy_your_old_files_into_timestamp_backup.o: make_backup_folder.o
	@now=$$(date +%Y%m%d_%H%M%S); \
	cp -a src/. OldSwarmieCode/swarmie$$now/

copy_clone_files_into_right_palce.o:
	cp -a "CNM-SRWG-2017/CNM-SRWG 2017/." src/

remove_clone_junk_files.o:
	rm -rf CNM-SRWG-2017
##############################################

compile_gazebo: compile_gazebo_description.o
	catkin build

compile_gazebo_description.o:
	echo -e "\n\n description \n first we need to compile gazebo\n"

gazebo: gazebo_description.o
	./run.sh

gazebo_description.o:
	echo -e "\n\n description \n We are now running gazebo\n"








########################################
########################################
########################################



#############################
############Makefile Tutorial
#############################
#type make in terminal to run this makefile, or make all, make hello, ect..
#############################
ifeq (0,1)  #comment till endif
# this target will compile all the file
all:  # this is a target, a tab is needed after target to execute command
	g++ main.cpp function1.cpp function2.cpp -o hello
compile:
endif
#############################
ifeq (0,2)  #comment till endif
all: hello #make or make all executes hello

hello: main.o function1.o function2.o  # .o creates an object, make hello executes all our object files
	g++ main.o function1.o function2.o -o hello

main.o: main.cpp  # target space dependancy # -c means compile
	g++ -c main.cpp

function1.o: function1.cpp
	g++ -c function1.cpp

function2.o: function2.cpp
	g++ -c function2.cpp

clean: # make clean removes all object files and cleans executable file
	rm -rf *o hello
endif
#############################
ifeq (0,3)  #comment till endif
#declair the variable
CC = g++ #CC is a variable, we could change the compiler to gcc


CFLAGS = -c -Wall #CFLAGS is a variable, -C is for compilation, -Wall is for giving warning

all: hello

hello: main.o function1.o function2.o
	$(CC) main.o function1.o function2.o -o hello

main.o: main.cpp
	$(CC) $(CFLAGS) main.cpp

function1.o: function1.cpp
	$(CC) $(CFLAGS) function1.cpp

function2.o: function2.cpp
	$(CC) $(CFLAGS) function2.cpp

clean:
	rm -rf *o hello
endif	
#############################
########timers
#############################
ifeq (0,4)  #comment till endif
time2:
	@start=$$(date +%Y%m%d_%H%M); \
	echo $$start

time3:
	echo NOW

money:
	$(eval start := $(shell date +%s))
	sleep 2
	$(eval end := $(shell date +%s))
	echo "$@: ${start}"

time:
	@start=$$(date +%s); \
	echo $@: $$start
	@sleep 2
	@end=$$(date +%s); \
	echo $@: $$end
endif
