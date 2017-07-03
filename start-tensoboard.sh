#!/bin/bash
nohup tensorboard --logdir=run1:/root/.tensoboard --port 6006 > /root/.tensoboard/tensoboard.log &
