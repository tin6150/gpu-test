
This is containerization of GJ's cuda-example at
https://gitlab.com/gustav.r.jansen/cuda-examples

attempt to get binary to run gpu burn in and power load test on the greta gpu nodes.

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
