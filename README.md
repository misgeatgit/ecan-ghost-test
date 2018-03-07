
###RUNNING


1. load libattention module in opencog (*loadmodule opencog/attention/libattention.so*)

2. start the ecan system (*start-ecan*)

3. copy encanplot.gnu to opencog build dir

3. load test-ecan4.scm 

5. run *gnuplot ecanplot.gnu* to see the STI values of the the five rules live.

6. from another opencog shell, go to the scm shell and stimulate some words
   which are associated to one of the five rules and see if the sti of the
   associated rule spikes. In my current setup, I'm provide stimulus of 150.


**NB**
  Currently a working param config is as follows:
       AF_RENT_FREQUENCY = 0.5, MAX_SPREAD_PERCENTAGE = 0.8


