FROM gcc:8.2.0
LABEL maintainer="Peter Gyima peter.gyima@gimadigital.com>"

# lets upgrade and add net-tools
RUN apt-get update && apt-get upgrade -y && apt-get install -y net-tools && apt-get install -y less

# add ssh - taken from https://docs.docker.com/engine/examples/running_ssh_service/
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# change default port to 1947
RUN sed -i 's/#Port 22/Port 1947/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 1947
CMD ["/usr/sbin/sshd", "-D"]
