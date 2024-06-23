clc;
clear all;
close all;
%%
sim_no= 12;
initial_age= 10; nc1=125; nc4= 40; nc5= 30;
hws = get_param('simulation_model','modelworkspace');
hws.assignin('iba',initial_age);
hws.assignin('cl1',nc1);
hws.assignin('cl2',nc4);
hws.assignin('cl3',nc5);
a = sim('simulation_model.slx', 1070000);

%%
% close all;
figure(1)
plot(a.simout(:,7), a.simout(:,6))
xlabel('Cycle Count'), ylabel('Capacity(mAh)','linewidth', 8);

%%
data = a.simout; % Assuming your data is numeric


%%

% Get the values in the 7th column
col7_values = data(:, 8);

% Initialize variables
group_counter = 0;

% Initialize a structure to store organized data
cycle = struct();

for i = 1:size(data, 1)
    if col7_values(i) == 0
        if i == 1 || col7_values(i - 1) == 1
            group_counter = group_counter + 1;
            cycle(group_counter).type='charge';
            cycle(group_counter).data = [];
        end
    else
        if i == 1 || col7_values(i - 1) == 0
            group_counter = group_counter + 1;
            
            cycle(group_counter).type='discharge';
            cycle(group_counter).data = [];
            cycle(group_counter).data.Capacity = [];
            cycle(group_counter).data.Capacity=data(i, 6);
        end
    end

    if ~isfield(cycle(group_counter).data, 'Voltage_measured')
        cycle(group_counter).data.Voltage_measured = [];
        cycle(group_counter).data.Current_measured = [];
        cycle(group_counter).data.SoC = [];
        cycle(group_counter).data.Temperature_measured = [];
        
    end
    
    
    cycle(group_counter).data.Voltage_measured = [cycle(group_counter).data.Voltage_measured; data(i, 1)];
    cycle(group_counter).data.Current_measured = [cycle(group_counter).data.Current_measured; data(i, 2)];
    cycle(group_counter).data.SoC = [cycle(group_counter).data.SoC; data(i, 3)];
    cycle(group_counter).data.Temperature_measured = [cycle(group_counter).data.Temperature_measured; data(i, 4)];
    
end
%%
% Save the organized data as a MAT file
matFilename = strcat('Bsim',num2str(sim_no),'.mat');
save(matFilename, 'cycle');
disp('MAT file saved successfully.');
