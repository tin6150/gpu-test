
This is containerization of GJ's cuda-example at
https://gitlab.com/gustav.r.jansen/cuda-examples

Container with binary to run gpu burn in and power load test on the greta gpu nodes.
node does not have nvcc, so use cloud container build to compile program
and run as docker binary.

(why did this repo get created with master branch?  rename to main needed quite a few steps!)

~~~~~

docker pull ghcr.io/tin6150/gpu-test:main
docker run -it --entrypoint=/bin/bash     ghcr.io/tin6150/gpu-test:main
docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v24Gb  # use 24GB of GPU memory
docker image push                         registry.greta.local:443/gpu-test:v24Gb  

docker run --gpus all -it --entrypoint=/bin/bash  registry.greta.local:443/gpu-test:v24Gb  
docker run --gpus all -it --entrypoint=/bin/bash  registry.greta.local:443/gpu-test:v24G_70min
docker run --gpus all -it --entrypoint=/opt/gitrepo/container/looped_sgemm/looped_sgemm.x  registry.greta.local:443/gpu-test:v24G_70min

## need to run 2 copies in parallel to load both GPU.
pdsh -w pxe-c00.greta.local docker run --gpus all -it --entrypoint=/opt/gitrepo/container/looped_sgemm/looped_sgemm.x  registry.greta.local:443/gpu-test:v24G_70min &
pdsh -w pxe-c00.greta.local docker run --gpus all -it --entrypoint=/opt/gitrepo/container/looped_sgemm/looped_sgemm.x  registry.greta.local:443/gpu-test:v24G_70min &


~~~~~

Gustav
  9:58 AM
https://gitlab.com/gustav.r.jansen/cuda-examples/-/tree/main/looped_sgemm
GitLabGitLab
looped_sgemm · main · Gustav Jansen / cuda-examples · GitLab
GitLab.com


tin
  9:59 AM
thanks Gustav!
9:59
where do you recommend I run the make?
10:00
did the c0000 node for example had all the tools you needed ?


Gustav
  10:00 AM
Run it on the machine where you have a gpu and cuda installed..
10:00
As long as nvcc is in the path, you're good to go..


tin
  10:00 AM
great!  thx!


Gustav
  10:03 AM
There are 2 options in the source:
minutes_to_run - minimum number of minutes you want it to run.
memory_usage_in_GB - Total amount of memory you want it to use.
Experiment to see how much memory usage it takes to have the GPU run at 100%.


tin
  10:03 AM
oh, ok.
10:03
gpu memory right?


Gustav
  10:03 AM
yes


~~~~~

