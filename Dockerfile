FROM hellgate75/tensorflow:1.2.1-gp27

MAINTAINER Fabrizio Torelli (hellgate75@gmail.com)

ARG DEBIAN_FRONTEND=noninteractive
ARG RUNLEVEL=1

ENV PATH=/usr/local/bin:/usr/local/go/bin:/opt/conda/bin:$PATH \
    GOROOT=/usr/local/go \
    GOPATH=/root/go \
    PACKAGE_NAME="myapp" \
    AUTO_BUILD=false \
    BUILD_ARGUMENTS="-buildmode=exe" \
    REPEAT_BUILD=false \
    JUPYTHER_TOKEN="7e7f9117ae5b96a8e69126ccb70841ec2911a051c6bb4ba7" \
    TENSORFLOW_LOG_FOLDER=/root/.tensoboard \
    GIT_URL="" \
    GIT_BRANCH="master" \
    GIT_USER="" \
    GIT_EMAIL="" \
    TARGZ_SOURCE_URL="" \
    TARGZ_ROOT_SSH_KEYS_URL="" \
    TARGZ_USER_SSH_KEYS_URL="" \
    DEBIAN_FRONTEND=noninteractive \
    CUDA_HOME=/usr/local/cuda \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/go/lib \
    LIBRARY_PATH=/usr/local/go/lib \
    TENSIOR_FLOW_VERSION=1.2.1 \
    MINICONDA_VERSION=4.3.21 \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jupyter \
    NB_UID=1000 \
    NB_GID=100 \
    GRANT_SUDO=yes \
    NB_HOME=/home/jupyter \
    LC_ALL="en_US.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    DISPLAY=:0

USER root

WORKDIR /opt

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen "en_US.UTF-8" && \
    gpg --keyserver pgpkeys.mit.edu --recv-key  010908312D230C5F && \
    gpg -a --export 010908312D230C5F | sudo apt-key add - && \
    apt-get update && \
    apt-get  --no-install-recommends install -y \
        git && \
    apt-get -y upgrade && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -Rf /root/tests

COPY run-tensior-flow.sh /usr/local/bin/run-tensior-flow
COPY start-tensoboard.sh /usr/local/bin/start-tensoboard

RUN chmod +x /usr/local/bin/run-tensior-flow && \
    mkdir -p /root/.tensoboard && \
    chmod +x /usr/local/bin/start-tensoboard

RUN wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz &&\
    rm -f go1.8.3.linux-amd64.tar.gz && \
    # Change to "gpu" for GPU support
    TF_TYPE="gpu" && \
    TARGET_DIRECTORY='/usr/local/go' && \
    curl -L "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-${TF_TYPE}-$(go env GOOS)-x86_64-1.2.1.tar.gz" | \
    tar -C $TARGET_DIRECTORY -xz && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add - && \
    apt-get update && \
    apt-get -y install bazel && \
    apt-get -y upgrade bazel && \
    cd /usr/local/go && \
    ldconfig && \
    mkdir -p /root/go/src && \
    go get github.com/tensorflow/tensorflow/tensorflow/go && \
    go test github.com/tensorflow/tensorflow/tensorflow/go

COPY tests/test.go /root/go/src/tests/main.go

WORKDIR /root

RUN go run /root/go/src/tests/main.go

VOLUME ["/root/tf-app", "/root/.tensoboard"]

ENTRYPOINT ["run-tensior-flow"]

# SSH
EXPOSE 22

# TensorBoard
EXPOSE 6006

# IPython
EXPOSE 8888
