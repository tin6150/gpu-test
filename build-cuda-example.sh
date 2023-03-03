#!/bin/bash

export BASE_DIR=/opt/gitrepo

cd $BASE_DIR/gpu-test/looped_sgemm

make | tee make.log

