clc; clear all; close all;

Battery= load('Bsim12.mat');
%Number= "Bsim12";
bname = "Bs12"

sample_time = 1;
Available_Profiles= length(Battery.cycle)  % Number of available profiles
% Data Cleansing 
invalid_cycles = []; %[1,84];%[115, 138]

for c= 1:length(invalid_cycles)
    Battery.cycle(invalid_cycles(c))=[];   
end

Battery.cycle(end)=[];  

n= length(Battery.cycle);           % Number of valid profiles


%% Charging Profile
total_cycles=0;
for i= 1:n
    
    profile= Battery.cycle(i).type();
    if strcmp(profile,'discharge')
        total_cycles=total_cycles+1;
    end
end

%%
% Finding the maximum length to store all the cycles together 
length_=0;
for i= 1:n
    profile= Battery.cycle(i).type();
    if strcmp(profile,'discharge')
        %Time
        
        V = [Battery.cycle(i).data.Voltage_measured];
        I = [Battery.cycle(i).data.Current_measured];
        T = [Battery.cycle(i).data.Temperature_measured];
        t = 0:sample_time:length(V)*sample_time; 
        t = t';
        
        length_new = length(V);
        if length_new>length_
           length_ = length_new;
        end
    end
end

%%

Capacity=[];
Cycle_voltages=[];


%all_encoded_data = zeros(L+2, min_length, total_cycles);
cycle_no=0;

for i= 1:n
    profile= Battery.cycle(i).type();
    if strcmp(profile,'discharge')
        cycle_no= cycle_no+1;

        %Time
        
        V = [Battery.cycle(i).data.Voltage_measured];
        I = [Battery.cycle(i).data.Current_measured];
        T = [Battery.cycle(i).data.Temperature_measured];
        t = 0:sample_time:(length(V)-1)*sample_time;
        t = t';

        length_new = length(V);
        plot(t,V, 'DisplayName', ['Cycle ', num2str(cycle_no)]);legend; hold on
        pause(0.01)

        V = [V' zeros(1,length_-length_new)];
        I = [I' zeros(1,length_-length_new)];
        T = [T' zeros(1,length_-length_new)];
        t = [t' zeros(1,length_-length_new)];

        %Capacity
        q = (Battery.cycle(i).data.Capacity);
        Capacity = [Capacity q];

        all_data(1, :,  cycle_no) = V;
        all_data(2, :,  cycle_no) = I;
        all_data(3, :,  cycle_no) = T;
        all_data(4, :,  cycle_no) = t;

         
    end
end

%%
save(strcat(bname,'.mat'), 'all_data', 'Capacity');

%%
figure(3)
% n = 3;
% new_capacity = medfilt1(capacity,n);
plot(abs(Capacity)), hold on;
xlabel('cycle_nos', Interpreter='latex'), ylabel('Discharge capacity', Interpreter='latex');

%%
loaded_data = load(strcat(bname,'.mat'));

% Access the loaded variables
loaded_all_data = loaded_data.all_data;
loaded_new_capacity = loaded_data.Capacity;
