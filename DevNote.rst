
This is containerization of GJ's cuda-example at
https://gitlab.com/gustav.r.jansen/cuda-examples

Container with binary to run gpu burn in and power load test on the greta gpu nodes.
node does not have nvcc, so use cloud container build to compile program
and run as docker binary.

(why did this repo get created with master branch?  rename to main needed quite a few steps!)

~~~~~

::

	docker pull ghcr.io/tin6150/gpu-test:main
	docker run -it --entrypoint=/bin/bash     ghcr.io/tin6150/gpu-test:main

	docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v24Gb       # use 24GB of GPU memory
	docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v24G_70min  # use 24GB of GPU memory and run for 70 minutes
	docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v24G_70min_quiet  # no elapsed time printf , power at 60W + 8W
	docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v20G_70min_quiet  # load ~150W, but need to ssh in interactive run -it 
	docker tag  ghcr.io/tin6150/gpu-test:main registry.greta.local:443/gpu-test:v20G_70min_mute  # no printf at all... 


	docker image push                         registry.greta.local:443/gpu-test:v20G_70min_mute	

	docker run --gpus all -it --rm --entrypoint=/bin/bash  registry.greta.local:443/gpu-test:v24Gb  
	docker run --gpus 0   -it --rm --entrypoint=/usr/bin/nvidia-smi  registry.greta.local:443/gpu-test:v24Gb  
	docker run --gpus all -it --rm --entrypoint=/bin/bash  registry.greta.local:443/gpu-test:v24G_70min_quiet

	docker run --gpus all -it --rm -e CUDA_VISIBLE_DEVICES=1 --entrypoint=/opt/gitrepo/container/looped_sgemm/looped_sgemm.x  registry.greta.local:443/gpu-test:v20G_70min_quiet

	## need to run 2 copies in parallel to load both GPU.
	pdsh -w pxe-c00.greta.local docker run --gpus all --rm  -e CUDA_VISIBLE_DEVICES=0 --entrypoint=/opt/gitrepo/container/looped_sgemm/looped_sgemm.x  registry.greta.local:443/gpu-test:v24G_70min_mute


~~~~~

::

	##>>## this version or method not getting high util, only 57W

	ipmitool sensor | grep -i watt
	Pwr Consumption  | 312.000    | Watts      | ok    | na        | na        | na        | 2592.000  | 2856.000  | na

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

