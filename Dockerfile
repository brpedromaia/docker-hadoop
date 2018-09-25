FROM centos:7
LABEL Pedro Maia Martins de Sousa <brpedromaia@gmail.com> and  Rodolfo Silva <Homaru> 

#######################################################
### Environment variables
#######################################################

ENV	HOME /root
ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8

USER root

#######################################################
### Default Installation
#######################################################

#RUN yum install -y curl tar sudo which initscripts openssh-server openssh-clients rsync 
RUN yum install -y which openssh-clients curl nc openssh-server openssl > /dev/null 2>&1

#######################################################
### Dev tools
#######################################################

#RUN yum install -y net-tools telnet mc git unzip

#######################################################
### Java Installation
#######################################################

RUN mkdir /temp-files
COPY jdk-8u181-linux-x64.rpmaa /temp-files
COPY jdk-8u181-linux-x64.rpmab /temp-files
RUN cat /temp-files/jdk-8u181-linux-x64.rpm* > /temp-files/jdk-8u181-linux-x64.rpm

RUN rpm -i /temp-files/jdk-8u181-linux-x64.rpm > /dev/null 2>&1
RUN yum clean all> /dev/null 2>&1

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

#######################################################
### Hadoop Installation
#######################################################

COPY hadoop.tar.gzaa /temp-files
COPY hadoop.tar.gzab /temp-files
COPY hadoop.tar.gzac /temp-files
RUN cat /temp-files/hadoop.tar.gz* > /temp-files/hadoop.tar.gz
RUN tar -C /usr/local/ -zxf /temp-files/hadoop.tar.gz

ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV HADOOP_CLIENT_OPTS " -Xmx2048m"

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:/usr/local/hadoop/bin

RUN	rm -rf  $HADOOP_PREFIX/etc/hadoop/*.cmd && chmod +x $HADOOP_PREFIX/etc/hadoop/*.sh

#######################################################
### SSH SERVER SETUP
#######################################################
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#######################################################
### Remove Temp Files Folder
#######################################################

RUN rm -rf /temp-files

#######################################################
### Entrypoint
#######################################################

ADD hadoop-entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

