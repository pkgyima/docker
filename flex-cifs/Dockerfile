FROM alpine:3.9.3
LABEL maintainer="Peter Gyima <peter.gyima@gimadigital.com>"

#location of kubelet plugins
ENV CIFS_PATH /var/kubelet-plugins/fstab~cifs/
ENV CIFS_STAGED_PATH /var/staged/cifs/

# download the cifs into the volume directory
RUN mkdir -p $CIFS_STAGED_PATH
ADD https://raw.githubusercontent.com/fstab/cifs/master/cifs $CIFS_STAGED_PATH

RUN chmod 755 $CIFS_STAGED_PATH/cifs

CMD ["sh", "-c", "mkdir -p $CIFS_PATH && cp $CIFS_STAGED_PATH/cifs $CIFS_PATH && sleep 9999999999"]
