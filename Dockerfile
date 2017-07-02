FROM hellgate75/ubuntu-base:16.04

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV PATH=$PATH:/usr/local/bin \
    DEBIAN_FRONTEND=noninteractive \
    TENSIOR_FLOW_VERSION=1.2.1 \
    TENSIOR_FLOW_TYPE=cp27

USER root

WORKDIR /opt

RUN apt-get update && \
    apt-get  --no-install-recommends install -y vim pciutils build-essential python-pip python-setuptools python-sklearn python-pandas python-numpy python-matplotlib software-properties-common python-software-properties && \
    apt-get -y upgrade && \
    pip install --upgrade pip

RUN echo "Install CUDA Nvidia drivers ..." && \
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub && \
    cat 7fa2af80.pub | apt-key add - && \
    rm 7fa2af80.pub && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb && \
    sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb && \
    rm cuda-repo-ubuntu1604_8.0.61-1_amd64.deb && \
    echo "deb http://ftp.debian.org/debian experimental main" >> /etc/apt/sources.list && \
    sudo apt-get update && \
    apt-get --no-install-recommends --allow-unauthenticated  install -y cuda

COPY run-tensior-flow.sh /usr/local/bin/run-tensior-flow

RUN chmod +x /usr/local/bin/run-tensior-flow

RUN echo "Install cuDNN Nvidia library ..." && \
    wget -q http://appliances-us-west-2.s3-us-west-2.amazonaws.com/cuDNN/cudnn-8.0-linux-x64-v6.0.tgz -O /opt/cudnn-8.0-linux-x64-v6.0.tgz && \
    tar -xzf /opt/cudnn-8.0-linux-x64-v6.0.tgz -C /opt/ && \
    rm -f /opt/cudnn-8.0-linux-x64-v6.0.tgz && \
    mv /opt/cuda /opt/cuDNN-6 && \
    export LD_LIBRARY_PATH=/opt/cuDNN-6/lib64:$LD_LIBRARY_PATH

RUN pip install --upgrade \
      https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-$TENSIOR_FLOW_VERSION-$TENSIOR_FLOW_TYPE-none-linux_x86_64.whl && \
    mkdir -p /root/tests && mkdir -p /root/tf-app

COPY tests/test.py /root/tests/test.py

RUN python /root/tests/test.py

WORKDIR /root

VOLUME ["/root/tf-app"]

ENTRYPOINT ["run-tensior-flow"]
