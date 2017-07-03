FROM hellgate75/ubuntu-base:16.04

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV PATH=$PATH:/usr/local/bin::/usr/local/go/bin \
    GOROOT=/usr/local/go \
    GOPATH=/root/go \
    DEBIAN_FRONTEND=noninteractive \
    TENSIOR_FLOW_VERSION=1.2.1 \
    TENSIOR_FLOW_TYPE=cp27 \
    LD_LIBRARY_PATH=/usr/local/go/lib \
    LIBRARY_PATH=/usr/local/go/lib

USER root

WORKDIR /opt

RUN apt-get update && \
    apt-get  --no-install-recommends install -y \
        git \
        vim \
        pciutils \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        rsync \
        python-pip \
        python-setuptools \
        python-sklearn \
        python-pandas \
        python-numpy \
        python-matplotlib \
        software-properties-common \
        python-software-properties && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip
RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        pandas \
        Pillow \
        && \
    python -m ipykernel.kernelspec && \
    pip install --upgrade \
      https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-$TENSIOR_FLOW_VERSION-$TENSIOR_FLOW_TYPE-none-linux_x86_64.whl && \
    mkdir -p /root/tf-app


RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz &&\
    rm -f go1.8.3.linux-amd64.tar.gz && \
    # Change to "gpu" for GPU support
    TF_TYPE="cpu" && \
    TARGET_DIRECTORY='/usr/local/go' && \
    curl -L \
     "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-${TF_TYPE}-$(go env GOOS)-x86_64-1.2.1.tar.gz" | \
    tar -C $TARGET_DIRECTORY -xz && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - && \
    apt-get update && \
    apt-get -y install bazel && \
    apt-get -y upgrade bazel && \
    cd /usr/local/go && \
    ldconfig && \
    mkdir -p /root/go/src
    #  \
    # && go get github.com/tensorflow/tensorflow/tensorflow/go \
    # && go test github.com/tensorflow/tensorflow/tensorflow/go

COPY run-tensior-flow.sh /usr/local/bin/run-tensior-flow
COPY start-tensoboard.sh /usr/local/bin/start-tensoboard

RUN chmod +x /usr/local/bin/run-tensior-flow && \
    mkdir -p /root/.tensoboard

COPY tests/test.go /root/go/src/tests/main.go

WORKDIR /root/go/src/tests

# RUN go run /root/go/src/tests/main.go

WORKDIR /root

VOLUME ["/root/tf-app"]

ENTRYPOINT ["run-tensior-flow"]

# TensorBoard
EXPOSE 6006

# IPython
EXPOSE 8888
