FROM hellgate75/ubuntu-base:16.04

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV PATH=$PATH:/usr/local/bin \
    DEBIAN_FRONTEND=noninteractive \
    TENSIOR_FLOW_VERSION=1.2.1 \
    TENSIOR_FLOW_TYPE=cp27

USER root

WORKDIR /

RUN apt-get update && \
    apt-get  --no-install-recommends install -y python-pip python-setuptools python-sklearn python-pandas python-numpy python-matplotlib software-properties-common python-software-properties && \
    pip install --upgrade pip && \
    pip install --upgrade \
      https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-$TENSIOR_FLOW_VERSION-$TENSIOR_FLOW_TYPE-none-linux_x86_64.whl && \
    mkdir -p /root/tests && mkdir -p /root/tf-app

COPY tests/test.py /root/tests/test.py

RUN python /root/tests/test.py

WORKDIR /root

VOLUME ["/root/tf-app"]

ENTRYPOINT ["/bin/bash"]

CMD ["tail", "-f", "/dev/null"]
