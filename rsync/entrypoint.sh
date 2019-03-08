#!/bin/sh

# Entry point for rsync docker 
# Expects file containing rsync commands to be passed in
# Each line is executed as an rsync command arguments
# the program pauses for FREQ seconds passed in as an environment variables

# run the rsync daemon in detach mode
rsync --daemon -4

# run the commands every FREQ seconds
while [ 1 ]
do
   if [ $# -eq 0 ] || [ -z "$1" ] || ! { [ -e "$1" ] && [ -f "$1" ] && [ -r "$1" ] && [ -s "$1" ]; };
   then
      echo "commands file not available. sleeping forever ..."
      sleep 4512568 # sleep for a long time
   else
      while read -r line || [[ -n "$line" ]]
      do
         rsync $line
      done < "$1"
      # sleep set in env variable FREQ
      sleep $FREQ
   fi
done

