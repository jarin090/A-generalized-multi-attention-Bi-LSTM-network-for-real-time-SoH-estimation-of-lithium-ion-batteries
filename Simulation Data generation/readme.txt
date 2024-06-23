1. The parameters of the 'simulation_model.slx' file should be set according to the datasheet of a specific battery that you want to model. 
   Check Simulink documentation for the 'Battery' block to know how to extract parametrs from datasheet.
   Also read the paper to get an idea 'A Generic Cycle Life Model for Lithium-ion Batteries Based on Fatigue Theory and Equivalent Cycle 
   Counting' of aging related parameters.

2. If you want to generate multiple data from same battery model, you can vary the aging characteristics. For which, you will have to vary 
   the aging parameters of the simulation model 'simulation_model.slx'. In the provided model, four aging parameters are set as 'variables'.
   Edit and run the 'sim_data.m' file which enables to vary the values of these parameters, runs the Simulink model with the changed value 
   and stores charging+ discharging voltage, current, temperature and capacity measurements.

3. The 'discharge_data_storing.m' file is for storing the discharge data only.
   
4. 'Bsim12.mat' is sample generated simulation charging+ discharging data file and 'Bs12.mat' is separated discharging data file.