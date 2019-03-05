FROM alpine:3.9
LABEL maintainer="Peter Gyima peter.gyima@gimadigital.com>"

# set environment variables
#ENV RUN_USER                                rsync
#ENV RUN_GROUP                               rsync

# set user and user group
#RUN addgroup -S ${RUN_GROUP} && adduser -S ${RUN_USER} -G ${RUN_GROUP}

# lets upgrade 
RUN apk update 

# rsync, vim, net-tools
RUN apk add rsync
RUN apk add less

# lets run as user
#USER ${RUN_USER}

# start the application
CMD ["rsync", "--daemon", "--no-detach", "-4"]