#!/bin/bash
#######################################################
### Users Setup - BEGGIN
#######################################################
touch /etc/sudoers
chmod 555 /etc/sudoers


#creating .bashrc default
echo 'export HADOOP_HOME=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_PREFIX=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_COMMON_HOME=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_HDFS_HOME=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_MAPRED_HOME=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_YARN_HOME=/usr/local/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop'>>/etc/skel/.bashrc
echo 'export YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop'>>/etc/skel/.bashrc
echo 'export HADOOP_CLIENT_OPTS=" -Xmx2048m"'>>/etc/skel/.bashrc
echo 'export HIVE_HOME /usr/local/hive'>>/etc/skel/.bashrc
echo 'export HCAT_HOME $HIVE_HOME/hcatalog/'>>/etc/skel/.bashrc
echo 'export CLASSPATH $CLASSPATH:/usr/local/hadoop/lib/*:$HIVE_HOME/lib/*:.'>>/etc/skel/.bashrc
echo 'export PATH $PATH:$HIVE_HOME/bin'>>/etc/skel/.bashrc
echo 'export PATH=$PATH:/usr/local/hadoop/bin'>>/etc/skel/.bashrc
echo 'export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:/usr/local/hive/lib/*:.'>>/etc/skel/.bashrc
echo 'export PATH=$PATH:/usr/local/hive/bin'>>/etc/skel/.bashrc
echo 'export LANG=en_US.UTF-8'>>/etc/skel/.bashrc
echo 'export LC_ALL=en_US.UTF-8'>>/etc/skel/.bashrc
echo 'export JAVA_HOME=/usr/java/default'>>/etc/skel/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin'>>/etc/skel/.bashrc
chmod 755 /etc/skel/.bashrc


usernames="hdfs,hive,sqoop"
usernames=(${images//,/ })

USERID=1000
GROUPID=1000
groupadd -g $GROUPID users

for i in "${images[@]}"
do
  # Creating user
  USERNAME="${i}"
  PASSWORD="${i}"
  USERID=$((USERID+1))
  USERDIR=/home/$USERNAME

  echo "Creating user $USERNAME (uid=$USERID,gid=$GROUPID,dir=$USERDIR)"
  useradd -m -d /home/${USERNAME^} -p $(openssl passwd -1 $PASSWORD) -s /bin/bash -G $GROUPID $USERNAME

  # Sudo
  sed -i '/'"$USERNAME"' ALL=.*/d' /etc/sudoers
  echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

  #cp /etc/skel/.bashrc $USERDIR/.bashrc
  chmod 755 $USERDIR/.bashrc
  chown $USERNAME:$GROUPID $USERDIR/.bashrc
done

/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D&
#######################################################
### Users Setup - END
#######################################################