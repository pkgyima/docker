#!/bin/sh

# Entry point for myip docker 

# run the update commands every FREQ seconds
while [ 1 ]
do
   resp=$(curl -X $UPDATE_METHOD -H "User-Agent: $USER_AGENT" -d "$ENC_DATA" $SITE_URL)
   echo "$resp"
   # parse the results and update google dns if successful
   # The following variables should be set as environmental variables
   #GOOGLE_URL=domains.google.com/nic/update
   #HOST_NAMES=subdomain1.domain.com,subdomain2.domain.com
   #GOOGLE_USERNAMES=username1,username2
   #GOOGLE_PASSWORDS=password1,password2
   # convert the host names into an array
   IFS=,
   host_names=($HOST_NAMES)
   usernames=($GOOGLE_USERNAMES)
   passwords=($GOOGLE_PASSWORDS)
   # check the number of hostnames, usernames and passwords are equal
   if [[ ${#host_names[@]} -le ${#usernames[@]} ]] && [[ ${#host_names[@]} -le ${#passwords[@]} ]]; then
      # remove any white space in the response received
      resp=$(echo -e "${resp}" | tr -d '[:space:]')
	  # check if the successfull response was received  
      searchstring='"success":true'
      # get string after success
      rest=${resp#*$searchstring}
      # if success was true, rest should be different from resp 
      if [ ! "$resp" = "$rest" ]; then
         # find myip value
         searchstring='"myip":"'
         myip=${rest#*$searchstring}
         # text before the next " is the ip address
         searchstring='"'
         myip=${myip%*$searchstring*}
         # if the response has other values beyond my ip, we need to remove them too
         aip=${myip%*$searchstring*}
         while [ ! "$myip" = "$aip" ]
         do
            myip=$aip
            aip=${myip%*$searchstring*}
         done
         # update the google domain with the new ip
         cnt=0
         for host_name in $HOST_NAMES
         do
            echo "$(($cnt + 1)): updating google dns ... setting $host_name ip to $myip"
            resp=$(curl -H 'User-Agent: Chrome/7.16' -X POST https://${usernames[$cnt]}:${passwords[$cnt]}@$GOOGLE_URL?hostname=$host_name&myip=$myip)
            echo "$resp"
            cnt=$(($cnt + 1))
         done
      fi
	fi
   # sleep set in env variable FREQ
   sleep $FREQ
done

