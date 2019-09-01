#!/bin/sh
#####################################################################
# Copyright (c) 2019 GIMA Digital Solutions Limited
#####################################################################
# Entry point for myip docker 
# given a comma separated list, get the nth item
# $1 list, $2 nth position (0-based index), $3 delimeter 
# returns the position element 
element() {
   if [ ! $1 ]; then 
      # empy list was sent, return nothing
	  echo ""
      return 1
   fi 
   if [ ! $2 ]; then 
      # we don't know what we're looking for 
	  echo ""
      return 1
   fi 
   if [ ! $3 ]; then 
	  echo $1
      return 1
   fi 
   # check if the  nth item exist
   elem_count=$(echo "$1" | grep -o $3 | wc -l)
   if [ $2 -gt $elem_count ]; then 
      echo ""
	  return 1
   fi
   lhalf="$1"
   pos=$2
   searchstring="$3"
   rhalf=${lhalf#*$searchstring}
   # move to nth item 
   icnt=0
   while [ $icnt -lt $pos ]
   do 
      lhalf=$rhalf
      rhalf=${lhalf#*$searchstring}
      icnt=$(($icnt + 1))
   done 
   # we've found the element
   if [ "$lhalf" = "$rhalf" ]; then
      # is  the last one on the list
      echo $rhalf
       return 0
   fi   
   # is in the middle of the list
   len=$((${#lhalf} - ${#rhalf} -1))
   echo ${lhalf:0:$len}
}
# get the list separator if defined
if [ -z "$LIST_SEP" ]; then
   list_sep="," # defaults to comma separated list
else
   list_sep=$LIST_SEP
fi
echo "list separator set to '$list_sep'"
## run the update commands every FREQ seconds
while [ 1 ]
do
   resp=$(curl -X $UPDATE_METHOD -H "User-Agent: $USER_AGENT" -d "$ENC_DATA" $SITE_URL)
   echo "$resp"
   # check that hostnames, usernames and passwords are all set and are not empty
   if [[ "$HOST_NAMES" ]] && [[ "$GOOGLE_USERNAMES" ]] && [[ "$GOOGLE_PASSWORDS" ]]; then
      # parse the results and update google dns if successful
      # The following variables should be set as environmental variables
      #GOOGLE_URL=domains.google.com/nic/update
      #HOST_NAMES=subdomain1.domain.com,subdomain2.domain.com
      #GOOGLE_USERNAMES=username1,username2
      #GOOGLE_PASSWORDS=password1,password2
      # get the number of hosts, usernames, passwords - we use the minimum
      cnt=$(echo "$HOST_NAMES" | grep -o $list_sep | wc -l)
      nsize=$(echo "$GOOGLE_USERNAMES" | grep -o $list_sep | wc -l)
      if [ $nsize -lt $cnt ]; then 
         cnt=$nsize 
      fi
      nsize=$(echo "$GOOGLE_PASSWORDS" | grep -o $list_sep | wc -l)
      if [ $nsize -lt $cnt ]; then 
         cnt=$nsize 
      fi
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
         while [ $cnt -ge 0 ]
         do
            host_name="$(element $HOST_NAMES $cnt $list_sep)"
            username="$(element $GOOGLE_USERNAMES $cnt $list_sep)"
            password="$(element $GOOGLE_PASSWORDS $cnt $list_sep)"
            echo "$(($cnt + 1)): updating google dns ... setting $host_name ip to $myip"
            resp=$(curl -H "User-Agent: $USER_AGENT" -X POST https://$username:$password@$GOOGLE_URL?hostname=$host_name&myip=$myip)
            echo "$resp"
			cnt=$(($cnt - 1))
         done
      fi
	fi
   # sleep set in env variable FREQ
   sleep $FREQ
done

