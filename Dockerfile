# Pull base image.
FROM bigboards/cdh-base-x86_64

MAINTAINER bigboards
USER root

ENV NOTVISIBLE "in users profile"

# Install hadoop-client
RUN apt-get update \
    && apt-get install -y hadoop-client hbase libssl-dev libffi-dev python-dev python-pip spark-core spark-history-server spark-python pig oozie-client impala-shell openssh-server libfreetype6-dev libpng-dev libjpeg8-dev libfreetype6 libxft-dev tmux vim unzip zip \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/* \
    && mkdir /var/run/sshd \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && echo "export VISIBLE=now" >> /etc/profile \
	&& chsh -s /bin/bash bb

# install pip for python 3.X
RUN apt-get update \
	&& apt-get install -y python3-pip

# Install python-packages
RUN pip install -U numpy \
	&& pip install -U matplotlib \
	&& pip install -U Cython \
	&& pip install -U pandas \
	&& pip install -U happybase \
	&& pip install -U pandas-ply \
	&& pip install -U dplython \
	&& pip install -U scikit-learn \
	&& pip install -U requests tabulate future six pytz hdfs python-dateutil influxdb fastavro \
	&& pip install http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/5/Python/h2o-3.10.4.5-py2.py3-none-any.whl

# install packages for python 3
RUN pip3 install -U numpy \
	&& pip3 install -U matplotlib \
	&& pip3 install -U Cython \
	&& pip3 install -U pandas \
	&& pip3 install -U happybase \
	&& pip3 install -U pandas-ply \
	&& pip3 install -U dplython \
	&& pip3 install -U scikit-learn \ 
	&& pip3 install -U requests tabulate future six pytz hdfs python-dateutil influxdb fastavro \
	&& pip3 install http://h2o-release.s3.amazonaws.com/h2o/rel-ueno/5/Python/h2o-3.10.4.5-py2.py3-none-any.whl

# declare the volumes
RUN mkdir /etc/hadoop/conf.bb && \
    update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.bb 1 && \
    update-alternatives --set hadoop-conf /etc/hadoop/conf.bb
VOLUME /etc/hadoop/conf.bb

# external ports
EXPOSE 2222

CMD ["/usr/sbin/sshd", "-D"]
