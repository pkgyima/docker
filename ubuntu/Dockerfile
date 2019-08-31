FROM atlassian/bitbucket-server:6.2.0-ubuntu
LABEL maintainer="Peter Gyima <peter.gyima@gimadigital.com>"

# lets upgrade 
RUN apt-get update && apt-get upgrade -y 

# install less, net-tools, vim, cifs-utils
RUN apt-get install -y net-tools 
RUN apt-get install -y less
RUN apt-get install -y vim
RUN apt-get install -y cifs-utils

