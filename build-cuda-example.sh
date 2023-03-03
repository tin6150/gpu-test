#!/bin/bash

export BASE_DIR=/opt/gitrepo/container

## dbg use:
cd $BASE_DIR
ls -la

cd $BASE_DIR/looped_sgemm
#cd $BASE_DIR/gpu-test/looped_sgemm

make | tee make.log

