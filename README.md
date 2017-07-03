#  TensorFlow™ Docker image


Docker Image for TensorFlow™. This Docker image provides Python, Java, C and Go execution environment.

Provided images :
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

Here about CUDA Nvidia toolkit :
https://developer.nvidia.com/cuda-toolkit

Here about cuDNN Nvidia library :
https://developer.nvidia.com/cudnn


### Goals ###

This docker images has been designed to be a test, development, integration, production environment for  TensorFlow™.
*No warranties for production use.*


### cuDA / cuDNN Build tips ###

Add /opt/cuDNN-6 to your build and link process by adding -I/opt/cuDNN-6/include to your compile line and -L/opt/cuDNN-6/lib64 -lcudnn to your link line.

See :

https://github.com/hellgate75/tensorflow/tree/1.2.1-gp27/docs/cudnn_install-2.txt


### Docker Image features ###

Here some information :

Volumes : /root/tf-app


`/root/tf-app` :

Folder to install sources.


Ports:

6006, 88888


`6006` :
TensorBoard™ WebUI Port


`8888` :
IPython WebUI Port


### TensiorFlow™ Docker Environment Entries ###

Here TensorFlow® environment variables :

* `PACKAGE_NAME` : Name of go language package assigned to your application
* `AUTO_BUILD` : (true/false) Flag defining auto-build of package on start-up (default: false)
* `REPEAT_BUILD` : (true/false) Flag defining auto-build on any start-up (default: false)
* `BUILD_ARGUMENTS` : flag defining auto-build of package on start-up (default: "-buildmode=exe") - See : https://golang.org/pkg/go/build/

### Sample command ###

Here a sample command to run TensiorFlow™ container:

```bash
docker run -d -v my/app/dir:/root/tf-app --name my-tensiorflow hellgate75/tensiorflow:1.2.1-gg183
```


You can run container with `-bash` argument for an on-flight execution and destroy, as follow :

```bash
docker run --rm -v my/app/dir:/root/tf-app --name my-tensiorflow hellgate75/tensiorflow:1.2.1-gg183 -bash my-command my-argument-1 ...  my-argument-n
```


*NOTE:*

For GPU docker container versions, please use nvidia-docker available at :

https://github.com/NVIDIA/nvidia-docker/wiki/Installation


### Test TensiorFlow™ console ###

In order to access to TensiorFlow™ shell :
```bash
    docker exec -it my-tensiorflow bash
```


Then, into docker container, type :

```bash
    go run /root/go/src/tests/main.go
```


### License ###

[LGPL 3](https://github.com/hellgate75/tensorflow/blob/master/LICENSE)
