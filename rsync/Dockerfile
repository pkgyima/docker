FROM alpine:3.9
LABEL maintainer="Peter Gyima peter.gyima@gimadigital.com>"

# set frequency of rsync
ENV FREQ  5 

# lets upgrade 
RUN apk update 

# rsync, vim, net-tools
RUN apk add rsync
RUN apk add less

#copy the entrypoint file
COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh 

ENTRYPOINT ["/bin/entrypoint.sh"]
