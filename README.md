#  TensorFlow™ Docker image


Docker Image for TensorFlow™. This Docker image provides Python, Java, C and Go execution environment.

Provided images :
* [MASTER - TensorFlow™ 1.2.1 with Python 2.7 CPU](https://github.com/hellgate75/tensorflow)
* [TensorFlow™ 1.2.1 with Python 2.7 CPU](https://github.com/hellgate75/tensorflow/tree/1.2.1-cp27)
* [TensorFlow™ 1.2.1 with Python 2.7 GPU](https://github.com/hellgate75/tensorflow/tree/1.2.1-gp27)
* [TensorFlow™ 1.2.1 with Go 1.8.3 CPU](https://github.com/hellgate75/tensorflow/tree/1.2.1-cg183)
* [TensorFlow™ 1.2.1 with Go 1.8.3 GPU](https://github.com/hellgate75/tensorflow/tree/1.2.1-gg183)


### Introduction ###

TensorFlow™ is an open source software library for numerical computation using data flow graphs. Nodes in the graph represent mathematical operations, while the graph edges represent the multidimensional data arrays (tensors) communicated between them. The flexible architecture allows you to deploy computation to one or more CPUs or GPUs in a desktop, server, or mobile device with a single API. TensorFlow was originally developed by researchers and engineers working on the Google Brain Team within Google's Machine Intelligence research organization for the purposes of conducting machine learning and deep neural networks research, but the system is general enough to be applicable in a wide variety of other domains as well.


Here some more info about  TensorFlow™ :
https://www.tensorflow.org/

Here some infromation about  TensorFlow™ develoment :
https://www.tensorflow.org/get_started/


### Goals ###

This docker images has been designed to be a test, development, integration, production environment for  TensorFlow™.
*No warranties for production use.*


### Docker Image features ###

Here some information :

Volumes : /root/tf-app, /root/.tensoboard/


`/root/tf-app` :

Folder to install sources.


`/root/.tensoboard` :

Folder collecting logs and event logs.


Ports:

6006, 88888, 22


`6006` :

 TensoBoard™ WebUI Port


`8888` :

IPython Jupyter WebUI Port


`22` :

SSH port (ssh public key will be printed in container logs)


### TensorFlow™ Docker Environment Entries ###

Here TensorFlow® environment variables :

* `JUPYTHER_TOKEN` : Jupyter access token (default: "7e7f9117ae5b96a8e69126ccb70841ec2911a051c6bb4ba7")


Here some auto-install source form remote source, environment variables :
* `TARGZ_ROOT_SSH_KEYS_URL` : URL to download tar gzipped root user ssh keys (default: "")
* `TARGZ_USER_SSH_KEYS_URL` : URL to download tar gzipped custom defined (jupyter) ssh keys (default: "")
* `TARGZ_SOURCE_URL` : URL to download tar gzipped source code (default: "")
* `GIT_URL` : Git repository URL (default: "")
* `GIT_BRANCH` : Git repository desired branch (default: "master")
* `GIT_USER` : Git repository user (default: "")
* `GIT_EMAIL` : Git repository email (default: "")


### Sample command ###

Here a sample command to run TensorFlow™ container:

```bash
docker run -d -v my/app/dir:/root/tf-app -p 8888:8888 -p 6006:6006 --name my-tensiorflow hellgate75/tensiorflow:1.2.1-cp27
```


You can run container with `-bash` argument for an on-flight execution and destroy, as follow :

```bash
docker run --rm -v my/app/dir:/root/tf-app -p 8888:8888 -p 6006:6006 --name my-tensiorflow hellgate75/tensiorflow:1.2.1-cp27 -bash my-command my-argument-1 ...  my-argument-n
```


*NOTE:*

For GPU docker container versions, please use nvidia-docker available at :

https://github.com/NVIDIA/nvidia-docker/wiki/Installation


You can enforce nvidia drivers and devices running :

```bash
nvidia-docker run [-d | --rm] --privileged  -v my/app/dir:/root/tf-app -p 8888:8888 -p 6006:6006 --name my-tensiorflow hellgate75/tensiorflow:1.2.1-cp27 ....
```


### TensorFlow™ development tips ###

TensorFlow™ TensoBoard event log folder is : `/root/.tensoboard`, please refer to this folder or use environment variable `TENSORFLOW_LOG_FOLDER` to set-up
code development reference to log event folder.


### Test TensorFlow™ console ###

In order to access to TensorFlow™ shell :
```bash
    docker exec -it my-tensiorflow bash
```


Then, into docker container, type :

```bash
    python /root/tests/test.py
```


In order to test TensorFlow™  TensoBoard, open in your browser :
```bash
http://{ host name | ip address | localhost }:6006
eg.:
http://localhost:6006
```


In order to test TensorFlow™ Jupyter Notebook Board (for testing and modify source), open in your browser :
```bash
http://{ host name | ipaddress | localhost }:8888/token={ configured token: JUPYTER_TOKEN }
eg.:
http://localhost:8888?token=7e7f9117ae5b96a8e69126ccb70841ec2911a051c6bb4ba7
```


### License ###

[LGPL 3](https://github.com/hellgate75/tensorflow/blob/master/LICENSE)
