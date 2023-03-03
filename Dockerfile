# Dockerfile for creating container to host cuda-examples by GJ -- for gpu benchmark on greta


## FROM debian:bullseye 
## FROM debian:bullseye ## vanilla container, no CUDA
## FROM nvidia/cuda:11.7.1-devel-ubuntu22.04  # hung A5000 with cuda 11.4/centos 7.9 (b15)
## FROM nvidia/cuda:11.2.1-devel-ubuntu18.04  # n0005 CUDA 11.2 >>  wrong opencl-icd
## FROM nvidia/cuda:11.4.2-devel-ubuntu18.04  # n0259 CUDA 11.4
FROM nvidia/cuda:11.4.2-devel-ubuntu20.04
#?? FROM nvidia/cuda:11.4.0-devel-centos7
# default aka :latest no longer supported.  https://hub.docker.com/r/nvidia/cuda

LABEL Ref="https://gitlab.com/gustav.r.jansen/cuda-examples"
LABEL Ref="https://github.com/tin6150/gpu-test"

MAINTAINER Tin_at_berkeley.edu
ARG DEBIAN_FRONTEND=noninteractive
#ARG TERM=vt100
ARG TERM=dumb
ARG TZ=PST8PDT
#https://no-color.org/
ARG NO_COLOR=1


# will use stand alone script to do most of the installation
# so that it can be used on singlarity (if not building from docker image)
# or perhaps installed on a cloud instance directly

RUN echo  ''  ;\
    touch _TOP_DIR_OF_CONTAINER_  ;\
    echo "This container build as os, then add additional package via standalone shell script " | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    export TERM=dumb      ;\
    export NO_COLOR=TRUE  ;\
    apt-get update ;\
    apt-get -y --quiet install apt-utils ;\
    apt-get -y --quiet install git  make gfortran gcc  ;\
    apt-get -y --quiet install git-all git-el ;\
    apt-get -y --quiet install python3-git python3-gitlab python3-github ;\
    apt-get -y --quiet install file wget curl gzip bash zsh fish tcsh less vim procps screen tmux ;\
    apt-get -y --quiet install python3 python-git-doc python-gitlab-doc ;\
    apt-get -y --quiet install apt-file ;\
    dpkg --list | tee -a dpkg--list.out ;\
    cd /    ;\
    echo ""

RUN echo ''  ;\
    echo '==================================================================' ;\
    test -d /opt/gitrepo            || mkdir -p /opt/gitrepo             ;\
    test -d /opt/gitrepo/container  || mkdir -p /opt/gitrepo/container   ;\
    #the git command dont produce output, thought container run on the dir squatting on the git files.  COPY works... oh well
    #git branch |tee /opt/gitrepo/container/git.branch.out.txt            ;\
    git log --oneline --graph --decorate | tee /opt/gitrepo/container/git.lol.out.txt       ;\
    #--echo "--------" | tee -a _TOP_DIR_OF_CONTAINER_           ;\
    #--echo "git cloning the repo for reference/tracking" | tee -a _TOP_DIR_OF_CONTAINER_ ;\
    cd /     ;\
    echo ""

COPY .              /opt/gitrepo/container/



# add some marker of how Docker was build.
RUN echo  ''  ;\
    touch _TOP_DIR_OF_CONTAINER_  ;\
    echo "begining docker build process at " | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | tee -a       _TOP_DIR_OF_CONTAINER_ ;\
    export TERM=dumb      ;\
    export NO_COLOR=TRUE  ;\
    cd /     ;\
    echo ""  ;\
    echo '==================================================================' ;\
    echo '==== building .... compiling .... using nvcc ...       ===========' ;\
    echo '==================================================================' ;\
    echo " calling external shell script..." | tee -a _TOP_DIR_OF_CONTAINER_  ;\
    date | tee -a      _TOP_DIR_OF_CONTAINER_                                 ;\
    echo '==================================================================' ;\
    cd /opt/gitrepo/container      ;\
    git branch | tee ./git.branch.out.txt                 ;\
    bash -x ./build-cuda-example.sh  2>&1 | tee build-cuda-example.teeOut.log ;\
    cd /    ;\
    echo ""

ENV DBG_CONTAINER_VER  "Dockerfile 2023.0303 draft1"
ENV DBG_DOCKERFILE Dockerfile


RUN  cd / \
  && touch _TOP_DIR_OF_CONTAINER_  \
  && echo  "--------" >> _TOP_DIR_OF_CONTAINER_   \
  && TZ=PST8PDT date  >> _TOP_DIR_OF_CONTAINER_   \
  && echo  $DBG_CONTAINER_VER   >> _TOP_DIR_OF_CONTAINER_   \
  && echo  "Grand Finale for Dockerfile"


ENV TZ America/Los_Angeles
# ENV TZ likely changed/overwritten by container's /etc/csh.cshrc



# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
ENTRYPOINT [ "/bin/bash" ]

# vim: shiftwidth=4 tabstop=4 formatoptions-=cro nolist nu syntax=on
