FROM fedora:41
 
RUN yum -y install openssh-server
 
RUN useradd remote_user && \
    echo "1234" | passwd remote_user  --stdin && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown -R remote_user:remote_user /home/remote_user/.ssh && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

RUN ssh-keygen -A

RUN yum -y install mysql
 
RUN yum -y install python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install awscli
    

CMD /usr/sbin/sshd -D